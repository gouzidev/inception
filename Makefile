all:
	sudo cp srcs/requirements/nginx/tools/hosts /etc/hosts
	cd srcs && sudo docker compose up --build
up : all

setup:
	sudo rm -f /etc/apt/sources.list.d/*docker*.list
	sudo apt clean
	sudo apt update -y
	sudo apt install curl -y
	sudo apt install software-properties-common apt-transport-https ca-certificates -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu oracular stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update -y
	sudo apt install docker-ce docker-ce-cli containerd.io uidmap -y

down: clean

clean:
	cd srcs && sudo docker compose down

fclean:
	cd srcs && sudo docker compose down && sudo docker system prune -f

re: clean all