# Setup Instructions for Modernized Login UI

This document provides instructions for completing the setup after the UI modernization changes.

## What Was Changed

### 1. Tailwind CSS Installation
- Added `tailwindcss-rails` gem to Gemfile
- Created `config/tailwind.config.js` with proper content paths
- Updated `app/assets/stylesheets/application.css` with Tailwind directives
- Created `Procfile.dev` for running Rails server and Tailwind watcher together
- Updated `bin/dev` to use foreman
- Updated `bin/setup` to automatically install Tailwind CSS

### 2. UI Updates
- **Login Page** (`app/views/sessions/new.html.erb`):
  - Full-height centered layout with gray background
  - Wave logo SVG icon at the top
  - Modern "Sign in to your account" heading
  - Stacked email/password inputs with placeholder text
  - Remember me checkbox with indigo styling
  - Forgot password link (placeholder, not functional yet)
  - Full-width indigo "Sign in" button
  - "Not a member? Create new account" CTA at bottom

- **Registration Page** (`app/views/registrations/new.html.erb`):
  - Matching centered card layout
  - Same wave logo and styling
  - Modern form inputs with placeholders
  - Improved error message display
  - Consistent indigo color scheme

### 3. Remember Me Functionality
- Created migration to add `remember_digest` column to users table
- Updated User model with:
  - Token generation methods
  - Remember/forget methods
  - Token authentication
- Updated SessionsController to handle remember_me checkbox
- Updated ApplicationController to support persistent sessions via cookies
- Added comprehensive tests for all remember_me functionality

### 4. Documentation
- Updated README.md with detailed setup instructions
- Created this SETUP_INSTRUCTIONS.md file

## Required Steps to Complete Setup

### Step 1: Install Dependencies

Ensure you have Ruby 4.0.1 installed. Then run:

```bash
bundle install
```

This will install all required gems including `tailwindcss-rails`.

### Step 2: Install Tailwind CSS

Run the Tailwind CSS installer:

```bash
bin/rails tailwindcss:install
```

This will:
- Download the Tailwind CSS standalone executable
- Create the `app/assets/builds` directory
- Set up the asset pipeline integration

### Step 3: Run Database Migration

Apply the new migration to add the `remember_digest` column:

```bash
bin/rails db:migrate
```

### Step 4: Build Tailwind CSS

Compile the Tailwind CSS for the first time:

```bash
bin/rails tailwindcss:build
```

### Step 5: Start the Development Server

Use the development command which will run both the Rails server and Tailwind watcher:

```bash
bin/dev
```

Or run them separately:

```bash
# Terminal 1
bin/rails server

# Terminal 2
bin/rails tailwindcss:watch
```

### Step 6: Run Tests

Verify all tests pass:

```bash
bin/rspec
```

Or run the full CI suite:

```bash
bin/ci
```

## Verification

After completing the setup:

1. Visit `http://localhost:3000/login`
2. You should see:
   - A centered login card with gray background
   - Wave icon logo at the top
   - Modern styled email and password inputs
   - Remember me checkbox
   - Forgot password link
   - Indigo "Sign in" button
   - "Create new account" link at the bottom

3. Visit `http://localhost:3000/signup`
4. You should see a matching registration form with similar styling

## Troubleshooting

### Tailwind Styles Not Appearing

If Tailwind classes are not rendering:

1. Make sure `tailwindcss-rails` gem is installed: `bundle list | grep tailwindcss`
2. Check that Tailwind CSS is running: `bin/rails tailwindcss:build`
3. Verify `app/assets/builds/tailwind.css` was generated
4. Clear browser cache and restart the server

### Remember Me Not Working

1. Ensure the migration has been run: `bin/rails db:migrate:status`
2. Check that `remember_digest` column exists: `bin/rails db:schema:dump`
3. Verify cookies are enabled in your browser

### Tests Failing

1. Make sure test database is up to date: `bin/rails db:test:prepare`
2. Run migrations in test environment: `RAILS_ENV=test bin/rails db:migrate`

## Next Steps (Future Enhancements)

The following features are noted but not yet implemented:

1. **Forgot Password Functionality**: The "Forgot password?" link is currently a placeholder. You may want to implement password reset functionality.

2. **Email Confirmation**: Consider adding email confirmation for new user registrations.

3. **OAuth Integration**: Add social login options (Google, GitHub, etc.)

4. **Two-Factor Authentication**: Enhance security with 2FA.

## File Changes Summary

### New Files
- `config/tailwind.config.js`
- `app/assets/images/logo.svg`
- `Procfile.dev`
- `db/migrate/20260116200000_add_remember_digest_to_users.rb`
- `SETUP_INSTRUCTIONS.md` (this file)

### Modified Files
- `Gemfile` - Added tailwindcss-rails gem
- `app/assets/stylesheets/application.css` - Added Tailwind directives
- `app/views/sessions/new.html.erb` - Modernized login UI
- `app/views/registrations/new.html.erb` - Modernized registration UI
- `app/models/user.rb` - Added remember_me methods
- `app/controllers/sessions_controller.rb` - Added remember_me handling
- `app/controllers/application_controller.rb` - Added persistent session support
- `bin/dev` - Updated to use foreman
- `bin/setup` - Added Tailwind CSS installation
- `README.md` - Updated with comprehensive documentation
- `spec/models/user_spec.rb` - Added remember_me tests
- `spec/requests/sessions_spec.rb` - Added remember_me tests
- `spec/system/authentication_spec.rb` - Updated button text and added UI element checks
