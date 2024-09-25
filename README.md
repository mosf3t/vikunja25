# README
Minimal configuration to get Vikunja up and running quickly. To make Vikunja available on a domain or with TLS termination, please see the official docs at:

https://vikunja.io/docs/full-docker-example

## Getting Started

Fire up a shell at project root directory and execute the following commands:

```sh
mkdir $PWD/files $PWD/db
chown 1000 $PWD/files $PWD/db
```

The first command makes directories for mapping volumes to host directories in order to persist state (db data, files) across restarts, upgrades, etc. The second command changes ownership to allow process in container to read/write directories/files on host.

Copy the env example to your own custom `.env` file:

```sh
cp .env.example .env
```

Copy the env overrides file to your own custom `.env.override`. This file can be empty but it must exist. 

Customize variables to suit your use case.

Run the start script:

```sh
npm run start
```

Once the container is running, seed the database with its first user:

```sh
npm run seed --email=YOUR_EMAIL_HERE --password=YOUR_PASSWORD_HERE --username=YOUR_USERNAME_HERE
```

Finally, navigate to the login page. By default that is at:

```sh
http://localhost:3456
```


## Usage

_Install Tools_

```sh
npm run install_tools
```

_Start_
```sh
npm run start
```

_Stop_
```sh
npm run stop
```

_Restart_
```sh
npm run restart
```

_Redeploy_
```sh
npm run redeploy
```

_Run all migrations_
```sh
npm run migrate:all
```

_List all migrations_
```sh
# This will give a list of migration ids (migration_id)
npm run list:migrations
```

_Rollback until a given migration_
```sh
# Syntax
npm run rollback:until migration_id={migration_id}

# Example
npm run rollback:until migration_id=20240315104205
```

## Makefile

The scripts in the project manifest (`package.json`) delegate many responsibilities to `Make`. This is a common strategy which provides many advantages:

* separation of concerns - separation of build/task configuration from package configuration
* reusability - reusable tasks and more elaborate build workflows as needed
* cross platform support - `Makefiles` can be used on various platforms including Linux, MacOS, Windows
* versatile syntax - powerful syntax to create complex build rules with variables, conditionals, patterns, dependencies, etc
* mature - `make` and `Makefile` have been in use since as early as 1976
* ubiquitous - widely known and used in Unix/Linux and C++ communities and as such both familiar and battle-hardened

Some examples of how to use the project `Makefile` are listed below:

_Install tools, build and start service_

```sh
make
```

_Create (register) a user_


```sh
make user email=YOUR_EMAIL_HERE password=YOUR_PASSWORD_HERE username=YOUR_USERNAME_HERE

```

_List users_


```sh
make list_users
```

_Reset password_

```sh
make reset_password userid=1 password=YOUR_PASSWORD_HERE
```

_Run all migrations_

```sh
make migrate_all
```

_Inspect Container_

```sh
make inspect_container
```

_Inspect Container Config_

```sh
make inspect_config
```

_Inspect Container Logs_

```sh
make inspect_logs
```

## Vikunja CLI

Note that a new user cannot presently be registered via the UI! The author of the project explains why here: 

https://community.vikunja.io/t/how-to-manage-users-in-self-hosted-instance/1062/5

This can be done, however, either using the convenience methods above or with the Vikunja CLI by passing the relevant commands to `docker exec` to execute in the container. 

In the following, please remember to replace `<container_name>` with the service container name; `<command>` with the Vikunja command; and `{flags}` with the relevant command line flags. 

For more information see the reference below to the official docs.

### Syntax

```sh
docker exec {container_name} /app/vikunja/vikunja {command} {flags}
```

### Examples

_Get Vikunja Help_

```sh
docker exec vikunja25 /app/vikunja/vikunja help
```

_Create User_

```
docker exec vikunja25 /app/vikunja/vikunja user create --email=YOUR_EMAIL_HERE--password=YOUR_PASSWORD_HERE --username=YOUR_USERNAME_HERE
```

For more information see the reference to the official docs below:


## References

[Official Docs | Vikunja CLI Usage](https://vikunja.io/docs/cli)
[Official Docs | Full Docker Example](https://vikunja.io/docs/full-docker-example)