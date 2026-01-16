require 'rails_helper'

RSpec.describe "Authentication", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  describe "User sign up" do
    it "allows a user to sign up" do
      visit signup_path

      fill_in "Name", with: "John Doe"
      fill_in "Email", with: "john@example.com"
      fill_in "Password", with: "password123"
      fill_in "Confirm Password", with: "password123"

      click_button "Sign Up"

      expect(page).to have_content("Account created successfully!")
      expect(page).to have_content("Welcome, John Doe!")
    end

    it "shows validation errors for invalid input" do
      visit signup_path

      # Fill in all fields to bypass HTML5 required validation
      fill_in "Name", with: ""  # Empty name should trigger validation
      fill_in "Email", with: "test@example.com"  # Valid email format
      fill_in "Password", with: "short"  # Too short password
      fill_in "Confirm Password", with: "short"

      click_button "Sign Up"

      expect(page).to have_content("Password is too short")
    end
  end

  describe "User login" do
    let!(:user) { User.create!(email: 'test@example.com', password: 'password123', name: 'Test User') }

    it "allows a user to log in with valid credentials" do
      visit login_path

      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "password123"

      click_button "Sign in"

      expect(page).to have_content("Logged in successfully.")
      expect(page).to have_content("Welcome, Test User!")
    end

    it "shows error for invalid credentials" do
      visit login_path

      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "wrongpassword"

      click_button "Sign in"

      expect(page).to have_content("Invalid email or password")
    end

    it "displays remember me checkbox" do
      visit login_path
      expect(page).to have_field("Remember me")
    end

    it "displays forgot password link" do
      visit login_path
      expect(page).to have_link("Forgot password?")
    end
  end

  describe "User logout" do
    let!(:user) { User.create!(email: 'test@example.com', password: 'password123', name: 'Test User') }

    it "allows a user to log out" do
      visit login_path
      fill_in "Email", with: "test@example.com"
      fill_in "Password", with: "password123"
      click_button "Log In"

      click_button "Log Out"

      expect(page).to have_content("Logged out successfully.")
      expect(page).to have_content("Log In")
    end
  end
end
