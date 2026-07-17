# ---------------------------------------------------------------------------- #
# Laravel Docker Starter Makefile
# ---------------------------------------------------------------------------- #

.PHONY: help init up down build restart logs bash composer artisan migrate fresh seed test pint npm install


# ---------------------------------------------------------------------------- #
# Help
# ---------------------------------------------------------------------------- #

help:
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "  make init        First project setup"
	@echo "  make up          Start Docker containers"
	@echo "  make down        Stop Docker containers"
	@echo "  make build       Rebuild Docker images"
	@echo "  make restart     Restart containers"
	@echo "  make logs        Show container logs"
	@echo "  make bash        Enter PHP container"
	@echo "  make composer    Run composer install"
	@echo "  make artisan     Run artisan command"
	@echo "  make migrate     Run migrations"
	@echo "  make fresh       Fresh migration with seed"
	@echo "  make seed        Run database seeders"
	@echo "  make test        Run tests"
	@echo "  make pint        Run Laravel Pint"
	@echo "  make npm         Run npm commands"
	@echo ""


# ---------------------------------------------------------------------------- #
# First Project Setup
# ---------------------------------------------------------------------------- #

init:

	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "✓ .env created"; \
	else \
		echo "✓ .env already exists"; \
	fi

	docker compose up -d --build

	@echo "Waiting for database..."
	@sleep 10

	docker compose exec app composer install

	docker compose exec app php artisan key:generate --force

	docker compose exec app php artisan config:clear

	docker compose exec app php artisan migrate --force

	docker compose exec app php artisan storage:link || true

	docker compose exec app php artisan optimize:clear

	@echo ""
	@echo "✓ Laravel project is ready"
	@echo ""


# ---------------------------------------------------------------------------- #
# Docker
# ---------------------------------------------------------------------------- #

up:
	docker compose up -d


down:
	docker compose down


build:
	docker compose build


restart:
	docker compose restart


logs:
	docker compose logs -f


# ---------------------------------------------------------------------------- #
# PHP Container
# ---------------------------------------------------------------------------- #

bash:
	docker compose exec app bash


# ---------------------------------------------------------------------------- #
# Composer
# ---------------------------------------------------------------------------- #

composer:
	docker compose exec app composer install


# ---------------------------------------------------------------------------- #
# Laravel Artisan
# ---------------------------------------------------------------------------- #

artisan:
	docker compose exec app php artisan


migrate:
	docker compose exec app php artisan migrate


fresh:
	docker compose exec app php artisan migrate:fresh --seed


seed:
	docker compose exec app php artisan db:seed


# ---------------------------------------------------------------------------- #
# Testing / Quality
# ---------------------------------------------------------------------------- #

test:
	docker compose exec app php artisan test


pint:
	docker compose exec app ./vendor/bin/pint


# ---------------------------------------------------------------------------- #
# Node
# ---------------------------------------------------------------------------- #

npm:
	docker compose exec app npm


# ---------------------------------------------------------------------------- #
# Installation
# ---------------------------------------------------------------------------- #

install:
	docker compose exec app bash scripts/install.sh
