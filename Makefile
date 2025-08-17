all:
	cd srcs && docker compose up


up:
	cd srcs && docker compose up

up_strong:
	cd srcs && docker compose up --build



down:
	cd srcs && docker compose down

down_bad:
	cd srcs && docker compose down --volumes
	cd srcs && docker image rm -f srcs-nginx:latest 
	cd srcs && docker image rm -f srcs-wordpress:latest 
	cd srcs && docker image rm -f srcs-mariadb:latest 
	sudo rm -rf /home/$(USER)/data/nginx/*
	sudo rm -rf /home/$(USER)/data/mariadb/*
	sudo rm -rf /home/$(USER)/data/wordpress/*


re:
	cd srcs && docker compose down && docker compose up

hard_reset: down_bad up_strong
	echo "Hard reset done ..."