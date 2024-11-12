+++
title = "Generate and serve files from Flask"
author = ["rudra kar"]
date = 2019-10-05
tags = ["python", "flask", "archive"]
draft = false
aliases = "/post/generate-and-serve-files-from-flask"
+++

Flask is one of the most used python frameworks for web development. Its
simplicity and extensibility makes it convenient for both small and
large applications alike.

In this blog we are going to create a simple flask web application that
will generate and serve files without storing them in the server.

> Note: For flask and python installation visit
> [flask documentation](https://flask.palletsprojects.com/en/1.1.x/)

Let's create a flask application with a basic route.

```python

from flask import Flask

app = Flask(__name__)


@app.route("/")
def index():
    return "Hello Flask!"
```

and voila! We have our server up and running with only 5 lines of code.

Now we need to create a route which will accept a file name as
parameter.

```python

@app.route("/file/<file_name>")
def get_file(file_name):
    return file_name
```

For our use case we need to generate a csv file using fake data.We need
to install [faker](https://github.com/joke2k/faker) to generate fake
data such as name, address, birthdate etc. Also we are using
[pandas](https://github.com/pandas-dev/pandas) to generate dataframes
that can be used to create both csv and spreadsheets.

```sh

python3 -m pip install faker pandas
```

Let's add functions that will generate csv files using the fake data we
get from Faker.

```python

def generate_fake_data():
    fake_data = [fake.simple_profile() for item in range(5)]
    return pd.DataFrame(fake_data)


def generate_csv_file(file_df):
    # Create an o/p buffer
    file_buffer = StringIO()

    # Write the dataframe to the buffer
    file_df.to_csv(file_buffer, encoding="utf-8", index=False, sep=",")

    # Seek to the beginning of the stream
    file_buffer.seek(0)
    return file_buffer
```

Now we need to call these functions from our routing method and send the
file as response.

```python

@app.route("/file/<file_name>")
def get_file(file_name):
    fake_df = generate_fake_data()
    generated_file = generate_csv_file(fake_df)
    response = Response(generated_file, mimetype="text/csv")
    # add a filename
    response.headers.set(
        "Content-Disposition", "attachment", filename="{0}.csv".format(file_name)
    )
    return response
```

Once we hit the above route with a file name the browser will ask for
permission to download the csv file.

Here is the full source code with a working example.

<div class="glitch-embed-wrap" style="height: 420px; width: 100%;">
  <iframe
    src="https://glitch.com/embed/#!/embed/bubble-curio?path=server.py&previewSize=0&sidebarCollapsed=true"
    title="exclusive-sneezeweed on Glitch"
    style="height: 100%; width: 100%; border: 0;">
  </iframe>
</div>

Feel free to edit and play around. Adios!
