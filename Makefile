all: up


up:
	cd srcs && docker compose build --pull
	cd srcs && docker compose up


down:
	cd srcs && docker compose down

down_bad:
	cd srcs && docker compose down --volumes
	cd srcs && docker image rm -f nginx
	cd srcs && docker image rm -f wordpress
	cd srcs && docker image rm -f mariadb
	sudo rm -rf /home/$(USER)/data/mariadb/*
	sudo rm -rf /home/$(USER)/data/wordpress/*


re:
	cd srcs && docker compose down && docker compose up

hard_reset: down_bad up
	echo "Hard reset done ..."