# Makefile

up:
	docker-compose up -d

down:
	docker-compose down

upp:
	docker-compose down && docker-compose up --build -d

bash:
	docker-compose exec web /bin/bash