all: up


up:
	docker compose -f srcs/docker-compose.yml build --pull
	docker compose -f srcs/docker-compose.yml up
	mkdir -p /home/sgouzi/data/mariadb /home/sgouzi/data/wordpress


down:
	docker compose -f srcs/docker-compose.yml down

down_bad: down
	docker image rm -f nginx
	docker image rm -f wordpress
	docker image rm -f mariadb

	sudo rm -rf /home/$(USER)/data/mariadb/
	sudo rm -rf /home/$(USER)/data/wordpress/
	mkdir -p /home/sgouzi/data/mariadb /home/sgouzi/data/wordpress
	
	docker image prune --force
	docker container prune --force
	docker volume prune --force


re:
	docker compose -f srcs/docker-compose.yml down && docker compose -f srcs/docker-compose.yml up

hard_reset: down_bad up
	echo "Hard reset done ..."