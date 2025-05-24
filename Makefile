PROJECT_NAME=inception

DC=docker-compose -f srcs/docker-compose.yml --env-file srcs/.env

LOCAL_VOLUMES = srcs/wordpress_data srcs/mariadb_data srcs/nginx_data

all: build up

build:
	$(DC) build

up:
	$(DC) up -d

down:
	$(DC) down

restart:
	$(DC) down
	$(DC) up -d

logs:
	$(DC) logs -f

ps:
	$(DC) ps

clean:
	$(DC) down -v --remove-orphans

fclean: clean
	@docker image prune -a -f
	@rm -r $(LOCAL_VOLUMES)

re: fclean all
