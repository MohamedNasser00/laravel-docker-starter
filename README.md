# Laravel Docker Starter

A reusable Laravel starter template with a complete Docker development environment for Laravel projects.

## Features

- PHP 8.4 FPM
- Nginx 1.27
- MySQL 8.4
- Composer 2
- Node.js 22
- phpMyAdmin
- Optimized Docker configuration
- Development & Production OPcache configuration
- One-command project initialization (`make init`)

---

## Requirements

Before using this template, make sure you have installed:

- Git
- Docker Desktop
- Docker Compose

---

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

---

# Getting Started

## 1. Create a new project from this template

Click **Use this template** on GitHub, create your new repository, then clone it.

```bash
git clone <repository-url>
cd project-name
```

---

## 2. Initialize the project

Run:

```bash
make init
```

This command should be executed **only once** for a new project.

It automatically:

- Creates `.env` from `.env.example` (if needed)
- Builds Docker images
- Starts all containers
- Runs the installation script

---

## 3. Install Laravel

If this template does **not** already contain Laravel, enter the container:

```bash
make bash
```

Create Laravel inside the project:

```bash
composer create-project laravel/laravel .
```

Exit the container:

```bash
exit
```

Run the installer:

```bash
make install
```

The installer will automatically:

- Install Composer dependencies
- Generate the application key
- Create the storage symlink
- Prepare Laravel database tables
- Run migrations
- Install Node packages (if `package.json` exists)
- Build frontend assets (if a build script exists)

---

# Available Commands

| Command | Description |
|----------|-------------|
| `make init` | First-time project setup |
| `make up` | Start Docker containers |
| `make down` | Stop Docker containers |
| `make build` | Rebuild Docker images |
| `make restart` | Restart containers |
| `make logs` | Show container logs |
| `make bash` | Enter the PHP container |
| `make composer` | Run Composer |
| `make migrate` | Run migrations |
| `make fresh` | Fresh migration with seed |
| `make seed` | Run seeders |
| `make test` | Run tests |
| `make pint` | Run Laravel Pint |
| `make npm` | Run npm commands |
| `make install` | Run the installation script |

---

# Database

Default Docker database configuration:

| Variable | Value |
|----------|-------|
| DB_HOST | mysql |
| DB_PORT | 3306 |

phpMyAdmin:

```
http://localhost:18080
```

---

# Environment Configuration

`make init` automatically creates `.env` from `.env.example`.

After the first setup, edit `.env` to match your project's requirements, such as:

- Application name
- Database credentials
- Mail configuration
- Third-party API keys

---

# Development

Enter the PHP container:

```bash
make bash
```

Example Laravel commands:

```bash
php artisan migrate

php artisan route:list

php artisan tinker

php artisan make:model Post -m
```

---

# Production Notes

Before deploying:

- Set `APP_ENV=production`
- Set `APP_DEBUG=false`
- Use secure database credentials
- Configure queue workers
- Enable HTTPS
- Use a secure `APP_KEY`
- Use the production OPcache configuration

---

# License

This template is free to use for personal and commercial Laravel projects.
