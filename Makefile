PROJECT_NAME=inception

DC=docker-compose -f srcs/docker-compose.yml --env-file srcs/.env

LOCAL_VOLUMES = /home/tbraud/data/wordpress_data /home/tbraud/data/mariadb_data /home/tbraud/data/nginx_data

all: build up

build:
	$(DC) build

up:
	$(DC) up

down:
	$(DC) down

logs:
	$(DC) logs -f

clean:
	$(DC) down -v --remove-orphans

fclean: clean
	@docker image prune -a -f
	@rm -r $(LOCAL_VOLUMES) 2>/dev/null || true

re: fclean all

.PHONY: all build up down logs clean fclean re
