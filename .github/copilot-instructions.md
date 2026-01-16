# GitHub Copilot Instructions for Fitness App

## Project Overview
This is a Ruby on Rails 8.1.2 application for fitness tracking. The project uses modern Rails conventions with Hotwire (Turbo and Stimulus), SQLite3 database, and is containerized using Docker with Kamal deployment.

## Technology Stack
- **Ruby Version**: 4.0.1
- **Rails Version**: ~> 8.1.2
- **Database**: SQLite3 (>= 2.1)
- **Frontend**: Hotwire (Turbo Rails, Stimulus), Importmap for JavaScript
- **Testing**: RSpec (~> 8.0.0) with Capybara for system tests
- **Styling**: Propshaft asset pipeline
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **WebSocket**: Solid Cable
- **Deployment**: Kamal with Docker

## Code Style and Conventions

### Ruby Style
- Follow **Omakase Ruby styling for Rails** as defined in `.rubocop.yml`
- Run `bin/rubocop` to check code style compliance
- The project inherits from `rubocop-rails-omakase` gem for consistent Rails conventions

### File Organization
- Models go in `app/models/`
- Controllers go in `app/controllers/`
- Views go in `app/views/`
- JavaScript goes in `app/javascript/`
- Shared concerns go in respective `concerns/` directories
- All models inherit from `ApplicationRecord`
- All controllers inherit from `ApplicationController`

## Testing

### Test Framework
- Use **RSpec** for all tests (not Minitest)
- Test files should be in `spec/` directory
- Follow the naming convention: `*_spec.rb` for test files
- Use Capybara with Selenium WebDriver for system tests

### Running Tests
- Run all tests: `bin/rails spec` (or `bundle exec rspec`)
- Run specific test: `bin/rails spec spec/path/to/test_spec.rb`
- The test database schema is maintained automatically

### Test Configuration
- Tests require `spec_helper` (configured in `.rspec`)
- Rails-specific test configuration is in `spec/rails_helper.rb`
- Test environment is isolated from development and production

## Development Workflow

### Setup
- Run `bin/setup` to set up the application for the first time
- This handles dependencies, database setup, and initial configuration

### Running the App
- Development server: `bin/dev`
- Rails console: `bin/rails console`
- Rails server: `bin/rails server`

### Database
- Create database: `bin/rails db:create`
- Run migrations: `bin/rails db:migrate`
- Seed data: `bin/rails db:seed`
- The project uses separate schemas for cache, cable, and queue stored in `db/`

## Code Quality and Security

### Continuous Integration
Run the full CI suite using `bin/ci`, which includes:
1. **Setup**: `bin/setup --skip-server`
2. **Style Check**: `bin/rubocop`
3. **Security Audits**:
   - Gem vulnerabilities: `bin/bundler-audit`
   - Importmap vulnerabilities: `bin/importmap audit`
   - Code analysis: `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`
4. **Tests**: `bin/rails test`
5. **Seed Test**: Test database seeding works

### Security Tools
- **Brakeman**: Static analysis for security vulnerabilities
- **Bundler Audit**: Checks gems for known security issues
- Always address security warnings before committing

## Deployment

### Docker
- Dockerfile is designed for production use
- Uses Ruby 4.0.1 slim base image
- Optimized with jemalloc for memory efficiency
- Build: `docker build -t fitness .`
- Run: `docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value> --name fitness fitness`

### Kamal
- Deployment managed via Kamal
- Configuration in `.kamal/` directory
- Deploy: `bin/kamal deploy`
- Use Thruster for HTTP asset caching and compression

## Dependencies and Package Management

### Adding Gems
- Add to `Gemfile` in the appropriate group (development, test, or production)
- Run `bundle install` after adding
- Commit both `Gemfile` and `Gemfile.lock`

### JavaScript Dependencies
- Managed via Importmap (not npm/yarn)
- Pin JavaScript packages: `bin/importmap pin <package>`

## Best Practices

### General
- Keep controllers thin, models fat
- Use concerns for shared behavior
- Prefer Active Record callbacks and validations over manual checks
- Use Turbo for SPA-like interactions without writing JavaScript

### Performance
- Leverage Solid Cache for caching
- Use Solid Queue for background jobs
- Optimize database queries with proper indexing and eager loading

### Assets
- Images should be processed using Active Storage with image_processing gem
- Use Propshaft for asset pipeline (not Sprockets)

### Health Checks
- The app provides a health check endpoint at `/up`
- Returns 200 if app boots successfully, 500 otherwise
- Useful for load balancers and monitoring

## Common Commands

```bash
# Development
bin/dev                          # Start development server
bin/rails console               # Open Rails console
bin/rails routes                # View all routes

# Testing
bin/rails spec                  # Run all RSpec tests
bin/rails spec spec/models      # Run specific directory tests

# Code Quality
bin/rubocop                     # Run style checker
bin/rubocop -a                  # Auto-fix style issues
bin/brakeman                    # Security scan
bin/bundler-audit               # Check gem vulnerabilities
bin/ci                          # Run full CI suite

# Database
bin/rails db:migrate            # Run migrations
bin/rails db:rollback           # Rollback last migration
bin/rails db:seed               # Seed database
bin/rails db:reset              # Drop, create, migrate, seed

# Deployment
bin/kamal deploy                # Deploy with Kamal
```

## Important Notes

- **Do not** use `bin/rails test` for writing new tests - use RSpec instead
- **Do not** commit `config/master.key` or any secrets to version control
- **Always** run security checks before committing changes
- **Always** ensure code passes RuboCop before committing
- The project follows Rails 8 conventions, including the use of Solid libraries
- Puma is the web server used in both development and production
