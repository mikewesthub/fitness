require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "GET /signup" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /signup" do
    let(:valid_params) do
      {
        user: {
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    it "creates a new user with valid params" do
      expect {
        post signup_path, params: valid_params
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(session[:user_id]).to eq(User.last.id)
    end

    it "does not create a user with invalid params" do
      invalid_params = valid_params.deep_merge(user: { email: 'invalid' })

      expect {
        post signup_path, params: invalid_params
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "does not create a user with mismatched passwords" do
      invalid_params = valid_params.deep_merge(user: { password_confirmation: 'different' })

      expect {
        post signup_path, params: invalid_params
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
