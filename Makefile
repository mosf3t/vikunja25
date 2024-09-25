# Description: Makefile for vikunja25 (WIP)
# Source: Based on OpenTelemetry Demo repository Makefile
# Author: mosf3t

# Variables
DOCKER ?= docker
DOCKER_COMPOSE_CMD ?= docker compose
DOCKER_COMPOSE_ENV=--env-file .env --env-file .env.override
VIKUNJA_CLI=/app/vikunja/vikunja
VIKUNJA_CONTAINER_NAME=vikunja25

.PHONY: all
all: install_tools build start

# Install tools
# Example: make install_tools
.PHONY: install_tools
install_tools: $(SOME_TOOL)
	npm install
	@echo "---"
	@echo "Tools installed"
	@echo "---"

# Build service
# Example: make build
.PHONY: build
build:
	$(DOCKER_COMPOSE_CMD) build
	@echo "---"
	@echo "Build completed"
	@echo "---"

# Start service
# Example: make start
.PHONY: start
start:
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) up --force-recreate --remove-orphans --detach
	@echo "---"
	@echo "Vikunja services started"
	@echo "Navigate to http://localhost:3456"
	@echo "---"

# Stop service and clean up
# Example: make stop
.PHONY: stop
stop:
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) down --remove-orphans --volumes
	@echo "---"
	@echo "Vikunja services stopped"
	@echo "---"

# Stop, remove, recreate and restart service
# Example: make restart service=vikunja25
# Note: As is, unless the service name is specified via the command line
# make will do nothing. This is expected behavior as there is currently
# only one service. As more services are added the rationale for this
# will become more apparent.
.PHONY: restart
restart:
# if <SERVICE> Makefile variable is defined, use it
ifdef SERVICE
	service := $(SERVICE)
endif

# otherwise use <service> command line argument
ifdef service
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) stop $(service)
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) rm --force $(service)
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) create $(service)
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) start $(service)
endif

# Rebuild and restart (redeploy) a single service component
# Example: make redeploy service=frontend
# Note: As is, unless the service name is specified via the command line
# make will do nothing. This is expected behavior as there is currently
# only one service. As more services are added the rationale for this
# will become more apparent.
.PHONY: redeploy
redeploy:
# if <SERVICE> Makefile variable is defined, use it
ifdef SERVICE
	service := $(SERVICE)
endif

# otherwise, use <service> command line argument
# Note that in the Makefile for the Otel demo the order of
# the stop and build commands is the inverse.
# There may be a good reason for this, but until I've 
# explored it a little more, I'm going to run with the more
# intuitive order of stop, rm, build, create, start.
ifdef service
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) stop $(service)
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) rm --force $(service)
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) build $(service)
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) create $(service)
	$(DOCKER_COMPOSE_CMD) $(DOCKER_COMPOSE_ENV) start $(service)
endif

# Create user
# Example: make user email=YOUR_EMAIL_HERE password=YOUR_PASSWORD_HERE username=YOUR_USERNAME_HERE
.PHONY: user
user:
	$(DOCKER) exec $(VIKUNJA_CONTAINER_NAME) $(VIKUNJA_CLI) user create --email=$(email) --password=$(password) --username=$(username)
	@echo "---"
	@echo "User created"
	@echo "Login with username: $(username) and password: $(password)"
	@echo "---"

# Reset password
# Example: make reset_password userid=YOUR_USER_ID_HERE password=YOUR_PASSWORD_HERE
.PHONY: reset_password
reset_password:
	$(DOCKER) exec $(VIKUNJA_CONTAINER_NAME) $(VIKUNJA_CLI) user reset-password $(userid) --direct --password=$(password)
	@echo "---"
	@echo "Password reset"
	@echo "Login with updated password: $(password)"
	@echo "---"

# List users
# Example: make list_users
.PHONY: list_users
list_users:
	$(DOCKER) exec $(VIKUNJA_CONTAINER_NAME) $(VIKUNJA_CLI) user list
	@echo "---"
	@echo "Users listed"
	@echo "---"

# Get list of migrations
# Example: make list_migrations
.PHONY: list_migrations
list_migrations:
	$(DOCKER) exec $(VIKUNJA_CONTAINER_NAME) $(VIKUNJA_CLI) migrate list
	@echo "---"
	@echo "Migrations listed"
	@echo "---"

# Run all database migrations that haven't already run
# Example: make migrate_all
.PHONY: migrate_all
migrate_all:
	$(DOCKER) exec $(VIKUNJA_CONTAINER_NAME) $(VIKUNJA_CLI) migrate
	@echo "---"
	@echo "Migrations run"
	@echo "---"

# Roll migrations back to a specific point (migration_id)
# Example: make rollback_until migration_id=1234567890
.PHONY: rollback_until
rollback_until:
	$(DOCKER) exec $(VIKUNJA_CONTAINER_NAME) $(VIKUNJA_CLI) migrate rollback --name=$(migration_id)
	@echo "---"
	@echo "Migrations rolled back to $(migration_id)"
	@echo "---"

# Inspect container
# Example: make inspect_container
.PHONY: inspect_container
inspect_container:
	$(DOCKER) inspect $(VIKUNJA_CONTAINER_NAME)
	@echo "---"
	@echo "Container inspected"
	@echo "---"

# Inspect container config
# Example: make inspect_config
.PHONY: inspect_config
inspect_config:
	$(DOCKER) inspect $(VIKUNJA_CONTAINER_NAME) --format='{{json .Config}}'
	@echo "---"
	@echo "Container config inspected"
	@echo "---"

# Inspect container logs
# Example: make inspect_logs
.PHONY: inspect_logs
inspect_logs:
	$(DOCKER) logs $(VIKUNJA_CONTAINER_NAME)
	@echo "---"
	@echo "Container logs inspected"
	@echo "---"