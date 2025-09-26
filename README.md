# Inception (42)

A 42 project deploying a multi-container stack with Docker: Nginx, WordPress (PHP-FPM), and MariaDB.

![Architecture Overview](docs/imgs/inception.webp)
![CGI Overview](docs/imgs/cgi.png)

## Table of Contents
- Overview
- Requirements
- Quick Start
- Project Structure
- Screenshots
- Troubleshooting
- License

## Overview
This setup runs WordPress backed by MariaDB and fronted by Nginx, fully isolated with Docker and configured via docker-compose.

## Requirements
- Docker and Docker Compose
- Make

## Quick Start
1. Clone and enter the project:
   ```bash
   git clone <your-repo-url> inception
   cd inception
   ```

2. Create your environment file:
   ```bash
   cp srcs/.env.example .env
   ```

3. Build and start everything:
   ```bash
   make
   ```

4. Open the site:
   - https://your_domain.42.fr (the domain:port you configured)

## Project Structure
```
inception
├── Makefile
├── README.md
├── .gitignore
├── docs
│   ├── README.md
│   └── imgs
│       ├── inception.webp
│       └── cgi.png
├── srcs
│   ├── .env.example
│   ├── docker-compose.yml
│   ├── requirements
│   │   ├── mariadb
│   │   │   ├── Dockerfile
│   │   │   ├── conf
│   │   │   │   └── 50-server.cnf
│   │   │   └── tools
│   │   │       └── init-db.sh
│   │   ├── nginx
│   │   │   ├── Dockerfile
│   │   │   ├── conf
│   │   │   │   └── nginx.conf
│   │   │   └── tools
│   │   │       └── entrypoint.sh
│   │   └── wordpress
│   │       ├── Dockerfile
│   │       ├── conf
│   │       │   └── php-fpm.conf
│   │       └── tools
│   │           └── setup.sh
```

## Screenshots
- Architecture
  ![Architecture Overview](docs/imgs/inception.webp)
- CGI
  ![CGI Overview](docs/imgs/cgi.png)

## Troubleshooting
- Rebuild from scratch:
  ```bash
  make fclean
  make
  ```
- Check logs:
  ```bash
  docker compose logs -f
  ```

## License
MIT. See LICENSE.