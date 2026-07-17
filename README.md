# Laravel Docker Starter

A reusable Laravel starter template with Docker environment setup.

This template provides a ready-to-use Docker development environment for Laravel projects with:

- PHP 8.4 FPM
- Nginx 1.27
- MySQL 8.4
- Composer 2
- Node.js 22
- phpMyAdmin
- Laravel optimized development configuration


## Requirements

Before using this template, make sure you have:

- Git
- Docker Desktop
- Docker Compose


## Project Structure

```text
laravel-starter/
│
├── docker/
│   ├── nginx/
│   │   └── default.conf
│   │
│   └── php/
│       ├── Dockerfile
│       ├── entrypoint.sh
│       ├── opcache.dev.ini
│       ├── opcache.prod.ini
│       └── uploads.ini
│
├── scripts/
│   └── install.sh
│
├── docker-compose.yml
├── Makefile
├── .env.example
├── .gitignore
├── .dockerignore
└── README.md
```


## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url> project-name
cd project-name
```

### 2. Initialize the project

```bash
make init
```

`make init` should be run only once when starting a new project. It automatically creates the `.env` file (if needed), starts the Docker containers, and installs the Laravel application.

This will start:

- PHP-FPM application container
- Nginx web server
- MySQL database
- phpMyAdmin

### What `make init` does

`make init` is intended to be run only once for a new project.

It automatically:

- Creates `.env` from `.env.example` (if it doesn't exist)
- Builds Docker images
- Starts all containers
- Installs Composer dependencies
- Generates the application key
- Creates the storage symlink
- Prepares Laravel database tables
- Runs database migrations
- Installs Node dependencies (if `package.json` exists)
- Builds frontend assets (if a build script exists)


## Available Commands

| Command          | Description                     |
| ---------------- | ------------------------------- |
| `make init`      | First-time project setup        |
| `make up`        | Start Docker containers         |
| `make down`      | Stop Docker containers          |
| `make build`     | Rebuild Docker images           |
| `make restart`   | Restart containers              |
| `make logs`      | Show container logs             |
| `make bash`      | Enter PHP container             |
| `make composer`  | Install Composer dependencies   |
| `make migrate`   | Run database migrations         |
| `make fresh`     | Fresh migration with seed       |
| `make seed`      | Run database seeders            |
| `make test`      | Run Laravel tests               |
| `make pint`      | Run Laravel Pint                |
| `make npm`       | Run npm commands                |


## Database

Default Docker database configuration:

| Variable           | Value     |
| ------------------ | --------- |
| `DB_HOST`          | mysql     |
| `DB_PORT`          | 3306      |

phpMyAdmin is available at:

```
http://localhost:18080
```


## Environment Configuration

`make init` automatically creates the `.env` file from `.env.example` if it does not already exist.

After the first setup, update the values in `.env` to match your project requirements (database credentials, application name, mail configuration, etc.).

The `.env.example` file includes default values for Docker development. The MySQL credentials in `.env.example` are synchronized with the Docker MySQL service configuration.


## Development

Enter the PHP container:

```bash
make bash
```

Example Laravel commands inside the container:

```bash
php artisan migrate
php artisan route:list
php artisan tinker
php artisan make:model Post -m
```


## Production Notes

Before deploying to production:

- Set `APP_ENV=production` and `APP_DEBUG=false`
- Use strong, unique database credentials
- Configure a proper queue worker if using queues
- Use HTTPS with valid SSL certificates
- Set a secure `APP_KEY` (do not use the development key)
- Review the OPcache production configuration in `docker/php/opcache.prod.ini`


## License

This starter template is free to use for personal and commercial Laravel projects.
