all: 
	cd srcs && docker compose up --build

up : all

down: clean

clean:
	cd srcs && docker compose down

fclean:
	cd srcs && docker compose down && docker system prune -f

re: clean all 