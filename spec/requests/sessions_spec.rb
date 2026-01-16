require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    let!(:user) { User.create!(name: 'beatrix', email: 'test@example.com', password: 'password123') }

    it "logs in with valid credentials" do
      post login_path, params: { email: 'test@example.com', password: 'password123' }
      expect(response).to redirect_to(root_path)
      expect(session[:user_id]).to eq(user.id)
    end

    it "does not log in with invalid email" do
      post login_path, params: { email: 'wrong@example.com', password: 'password123' }
      expect(response).to have_http_status(:unprocessable_content)
      expect(session[:user_id]).to be_nil
    end

    it "does not log in with invalid password" do
      post login_path, params: { email: 'test@example.com', password: 'wrongpassword' }
      expect(response).to have_http_status(:unprocessable_content)
      expect(session[:user_id]).to be_nil
    end
  end

  describe "DELETE /logout" do
    let!(:user) { User.create!(name: 'beatrix', email: 'test@example.com', password: 'password123') }

    it "logs out the current user" do
      post login_path, params: { email: 'test@example.com', password: 'password123' }
      delete logout_path
      expect(response).to redirect_to(root_path)
      expect(session[:user_id]).to be_nil
    end
  end
end
