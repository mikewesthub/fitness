# Fitness Tracker

A Ruby on Rails 8 application for fitness tracking with modern UI powered by Tailwind CSS.

## Ruby version

- Ruby 4.0.1
- Rails 8.1.2

## System dependencies

- SQLite3 >= 2.1
- Node.js (for Tailwind CSS standalone executable)

## Setup

After cloning the repository, run:

```bash
bin/setup
```

This will:
- Install Ruby gem dependencies
- Install Tailwind CSS
- Set up the database
- Run migrations

## Database creation and initialization

The database is created and initialized automatically by `bin/setup`. To do it manually:

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

## Running the application

For development, use:

```bash
bin/dev
```

This starts both the Rails server and the Tailwind CSS watcher.

Alternatively, you can run just the Rails server:

```bash
bin/rails server
```

And compile Tailwind CSS manually:

```bash
bin/rails tailwindcss:build
```

## How to run the test suite

```bash
bin/rspec
```

Or run the full CI suite:

```bash
bin/ci
```

## Features

- User authentication with email and password
- Remember me functionality for persistent sessions
- Modern, responsive UI with Tailwind CSS
- Secure password handling with bcrypt

## Deployment

The application is configured for deployment with Kamal. See `.kamal/` directory for configuration.

```bash
bin/kamal deploy
```

## Docker

Build and run the Docker container:

```bash
docker build -t fitness .
docker run -d -p 80:80 -e RAILS_MASTER_KEY=<your-key> --name fitness fitness
```

