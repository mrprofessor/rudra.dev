+++
title = "Generate beautiful JSON from PostgreSQL"
author = ["rudra kar"]
date = 2020-05-19
tags = ["postgresql", "json", "sql"]
draft = false
aliases = "/post/generate-beautiful-json-from-postgresql"
+++

<div class="ox-hugo-toc toc">

<div class="heading">Table of Contents</div>

- [1. Get the table data as JSON objects](#1-get-the-table-data-as-json-objects)
- [2. Get the table data with specific columns](#2-get-the-table-data-with-specific-columns)
- [3. Get the table data as a single JSON object](#3-get-the-table-data-as-a-single-json-object)
- [4. Build JSON object with multiple tables](#4-build-json-object-with-multiple-tables)
- [5. Build JSON object by resolving foreign keys](#5-build-json-object-by-resolving-foreign-keys)
- [Conclusion](#conclusion)

</div>
<!--endtoc-->

PostgreSQL provides a set of built-in [JSON
creation functions](https://www.postgresql.org/docs/current/functions-json.html#FUNCTIONS-JSON-CREATION-TABLE) that can be used to build basic JSON structures. This increases the performance up to 10 times more than building it at the back-end layer.

> This post is about building different JSON structures using PostgreSQL
> built-in functions. It doesn't talk about storing and manipulating
> JSON in PostgreSQL.

In order to proceed with some examples, first we need to setup a test
database.

```sql
CREATE DATABASE jsonland
```

Let's create the following tables.

```sql
CREATE TABLE "user" (
  id SERIAL NOT NULL,
  name VARCHAR(100),
  email_address VARCHAR(150),
  PRIMARY KEY(id)
)

CREATE TABLE team (
  id SERIAL NOT NULL,
  name VARCHAR(100),
  PRIMARY KEY(id)
)

CREATE TABLE team_user (
  id SERIAL NOT NULL,
  team_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(team_id) REFERENCES "team" (id),
  FOREIGN KEY(user_id) REFERENCES "user" (id),
  PRIMARY KEY(id)
)
```

Let's Seed the tables with random data.

```sql
INSERT INTO "team" ("id", "name")
VALUES (1, 'team1'), (2, 'team2');

INSERT INTO "user" ("id", "name", "email_address")
VALUES (1, 'user1', 'user1@mail.com'), (2, 'user2', 'user2@mail.com');

INSERT INTO "team_user" ("id", "team_id", "user_id")
VALUES (1, 1, 1), (2, 1, 2), (3, 2, 2);
```

We have created three tables i.e. `team`, `user` and `team_user`.
`team_user` table maps one-to-may the relationship between users and
teams.


## 1. Get the table data as JSON objects {#1-get-the-table-data-as-json-objects}

```sql
SELECT row_to_json("user") FROM "user";

+-----------------------------------------------------------+
| row_to_json                                               |
|-----------------------------------------------------------|
| {"id":1,"name":"user1","email_address":"user1@gmail.com"} |
| {"id":2,"name":"user2","email_address":"user2@gmail.com"} |
+-----------------------------------------------------------+
```

The above mentioned query will return all the columns of each row as
JSON objects.


## 2. Get the table data with specific columns {#2-get-the-table-data-with-specific-columns}

We can specify the particular columns we need rather than getting all at
once.

```sql
SELECT row_to_json(row('id', 'name')) FROM "user";

+-------------------------+
| row_to_json             |
|-------------------------|
| {"f1":"id","f2":"name"} |
| {"f1":"id","f2":"name"} |
+-------------------------+
```

Now certainly the keys `f1` and `f2` in the objects are not very useful
to us. We would rather want the column names instead of those keys.

```sql
SELECT row_to_json(users) FROM (SELECT id, name FROM "user") AS users;

+-------------------------+
| row_to_json             |
|-------------------------|
| {"id":1,"name":"user1"} |
| {"id":2,"name":"user2"} |
+-------------------------+
```


## 3. Get the table data as a single JSON object {#3-get-the-table-data-as-a-single-json-object}

The above examples return us multiple JSON objects(one for each row).
Ideally we would want a single array of these objects which won't need
any further manipulation at back-end layer.

```sql
SELECT array_to_json(array_agg(row_to_json(users)))
    FROM (
        SELECT id, name from "user"
    ) users

-- OR

SELECT json_agg(row_to_json(users))
    FROM (
        SELECT id, name from "user"
    ) users

+----------------------------------------------------+
| json_agg                                           |
|----------------------------------------------------|
| [{"id":1,"name":"user1"}, {"id":2,"name":"user2"}] |
+----------------------------------------------------+
```

In the above query we are aggregating all the JSON objects and using
`array_agg` and then converting them to JSON by applying `array_to_json`
function.

Also we could do the yield the same results by using `json_agg`
function, which results into an object instead of JSON string.


## 4. Build JSON object with multiple tables {#4-build-json-object-with-multiple-tables}

We can also build a new JSON object by using `json_build_object` and
specify the keys and values. Let's create an object that will contain
data from both team and user table.

```sql
SELECT json_build_object(
  'users', (SELECT json_agg(row_to_json("user")) from "user"),
  'teams', (SELECT json_agg(row_to_json("team")) from "team")
)
```

This query generates a JSON structure that will have all the users and
teams each as arrays of objects.

```json
{
  "users": [
    {
      "id": 1,
      "name": "user1",
      "email_address": "user1@mail.com"
    },
    {
      "id": 2,
      "name": "user2",
      "email_address": "user2@mail.com"
    }
  ],
  "teams": [
    {
      "id": 1,
      "name": "team1"
    },
    {
      "id": 2,
      "name": "team2"
    }
  ]
}
```


## 5. Build JSON object by resolving foreign keys {#5-build-json-object-by-resolving-foreign-keys}

We can generate JSON structures by resolving foreign key references and
joining multiple tables.

```sql
select json_agg(row_to_json(tu))
    from (
        select id, (
            select row_to_json(team) from team where team_user.team_id = team.id
        ) team, (
            select row_to_json("user") from "user" where team_user.user_id = "user".id
        ) "user"
    from team_user
) tu
```

This query contains multiple sub-queries to generate a complex
structure. It resolved the references of `team_id` and `user_id` into
the corresponding row.

```json
[
    {
      "id": 1,
      "team": {
        "id": 1,
        "name": "team1"
      },
      "user": {
        "id": 1,
        "name": "user1",
        "email_address": "user1@mail.com"
      }
    },
    {
      "id": 2,
      "team": {
        "id": 1,
        "name": "team1"
      },
      "user": {
        "id": 2,
        "name": "user2",
        "email_address": "user2@mail.com"
      }
    },
    {
      "id": 3,
      "team": {
        "id": 2,
        "name": "team2"
      },
      "user": {
        "id": 2,
        "name": "user2",
        "email_address": "user2@mail.com"
      }
    }
  ]
```


## Conclusion {#conclusion}

Even though PostgreSQL is almost always faster than the back-end
language based JSON generation, the query can get complex really quickly
as we have nested structures. As long as we understand the basic JSON
functions and sub-queries we can build almost any kind of structure
without stressing the back-end processes.
