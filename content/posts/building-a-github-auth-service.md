+++
title = "Building a GitHub authentication service"
author = ["mrprofessor"]
date = 2020-04-11
tags = ["github", "auth", "flask", "python"]
draft = false
aliases = "/post/building-a-github-auth-service"
+++

<div class="ox-hugo-toc toc">
<div></div>

<div class="heading">Table of Contents</div>

- [The GitHub OAuth process](#the-github-oauth-process)
- [Why do we need a back-end server](#why-do-we-need-a-back-end-server)
- [The proxy](#the-proxy)
- [Conclusion](#conclusion)

</div>
<!--endtoc-->

Recently I was building a GitHub OAuth app to authentiacate one my
client-side application with GitHub. The application was all about
taking notes and maintaining them on a private repository. I have had
worked on such an architecture in one of my previous jobs where we have
used [AWS CodeCommit](https://aws.amazon.com/codecommit/) as an
inventory of resources where the history and the changes were easier to
maintain. So for me GitHub was the perfect choice as a free storage with
elegant history/commit management.

Like most OAuth process it was not so straightforward even though at
first glance it seemed so.


## The GitHub OAuth process {#the-github-oauth-process}

After going through the GitHub's [guide](https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/) and a bunch of other development blogs I came up with a set of steps.

1.  First we need to create an OAuth application. The steps to create one are mentioned [here](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/).

2.  Once we create an OAuth application, we need to call the GitHub API
    for an authentication code. This API call looks something like this.

    ```text
            https://github.com/login/oauth/authorize?client_id=0000000000000&scope=repo&redirect_uri=https://xyz.io/myapp/
    ```

    This redirects to the redirect\_uri with an authentication code which
    looks something like this.

    ```text
            https://xyz.io/myapp/?code=a17ccd77d36b2be92aa4
    ```

3.  After getting the code, we need to make a POST call to get the
    access\_token.

    ```sh
              curl --location --request POST 'https://github.com/login/oauth/access_token' \
              --header 'Cookie: _octo=GH1.1.206637387.1578955864; logged_in=no' \
              --form 'client_id=xxxxxxxxxxxxxx' \
              --form 'client_secret=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' \
              --form 'code=a17ccd77d36b2be92aa4'
    ```

4.  Once we have the access\_token we can start making call to GitHub and
    interact with repositories. Here is an example to get the current
    user details.

    ```sh
              curl -H "Authorization: 2434543442242394sfes34dds" https://api.github.com/user
    ```

> Follow the official
> [web-application-flow](https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/#web-application-flow)
> guide for more details and all possible parameters of the
> authentication APIs.


## Why do we need a back-end server {#why-do-we-need-a-back-end-server}

Now with the above four steps it does look simple, doesn't it?

Well no! We really don't want to reveal our client secret to a possible
attacker, who in turn can get access to all the users and possibly their
repositories who had authorized this OAuth application. There is no
safer way to make the 3rd step from a client-side application without
revealing the client secret.

To securely call the POST API we need a back-end proxy where we can
store the client secret and make the call. The proxy could be an old
fashioned server as well as a serverless function hosted on a cloud
provider.


## The proxy {#the-proxy}

    We will be needing only one GET API on the proxy/server to authenticate
our client-side application. We will pre-configure our proxy/server with
client id and client secret and will accept the authentication code as a
parameter for the API.

The API call to the proxy/server should look something like this.

```text
  https://your-proxy.glitch.me/authenticate/a17ccd77d36b2be92aa4
```

Here we are using Python and Flask to build the server, but it can be
any stack of your choice.

```python
    @app.route("/authenticate/<code>", methods=["GET"])
    def authenticate(code):
        creds = get_access_token(*build_config(code))
        return jsonify(creds)


    def build_config(code):
        url = config["oauth_url"]
        headers = {"Content-Type": "application/json"}
        payload = {
            "client_id": os.environ.get(config["oauth_client_id"]),
            "client_secret": os.environ.get(config["oauth_client_secret"]),
            "code": code,
        }
        # Raise exceptions if client_id or client_secret not found.
        if not payload["client_id"]:
            raise APIException("Client Id is not found in environment", status_code=422)
        if not payload["client_secret"]:
            raise APIException("Client secret is not found in environment", status_code=422)
        return url, headers, payload


    def get_access_token(url, headers, payload):
        response = requests.post(url, headers=headers, params=payload)
        # If client id not found
        if response.text == "Not Found":
            raise APIException("Client id is invalid", status_code=404)
        qs = dict(parse_qsl(response.text))
        creds = {item: qs[item] for item in qs}
        return creds
```

Here we are storing the client id and client secret as environment
variable and using them to build the required parameters for the POST
call. We are also wrapping the default error message with a more
sophisticated one.


## Conclusion {#conclusion}

This kind of design is pretty common with most OAuth authentication
processes. Here for hosting I have used [Glitch](https://glitch.com/)
as it is free and easy to maintain. If you are expecting an high volume
of requests, a more serious server would be a better choice.

The complete source code can be found
[here](https://github.com/solitudenote/gitkeeper). Feel free to fork
and play around. Adios.
