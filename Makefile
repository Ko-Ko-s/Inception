DOCS=srcs/docker-compose.yml

all: create_dir build up


create_dir:
		mkdir -p /home/geldiss/data/wordpress
		mkdir -p /home/geldiss/data/mariadb

build:
		docker-compose -f $(DOCS) build

up:
		docker-compose -f $(DOCS) up

stop:
		docker stop $$(docker ps -aq)
		docker rm $$(docker ps -aq)

fclean:
		docker stop $$(docker ps -aq)
		docker rm $$(docker ps -aq)
		docker rmi $$(docker images -aq) -f
clrdata:
		docker volume rm $$(docker volume ls -q)
		sudo rm -rf ../../data/mariadb ../../data/wordpress
