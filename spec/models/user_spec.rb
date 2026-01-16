require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        name: 'beatrix',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(name: 'beatrix', email: nil, password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      User.create!(name: 'beatrix', email: 'test@example.com', password: 'password123')
      user = User.new(name: 'beatrix', email: 'test@example.com', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'is invalid with a duplicate email (case insensitive)' do
      User.create!(name: 'beatrix', email: 'test@example.com', password: 'password123')
      user = User.new(name: 'beatrix', email: 'TEST@EXAMPLE.COM', password: 'password123')
      expect(user).not_to be_valid
    end

    it 'is invalid with an invalid email format' do
      user = User.new(name: 'beatrix', email: 'invalid-email', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it 'is invalid with a short password' do
      user = User.new(name: 'beatrix', email: 'test@example.com', password: 'short')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  describe 'email normalization' do
    it 'downcases email before saving' do
      user = User.create!(
        name: 'beatrix',
        email: 'TEST@EXAMPLE.COM',
        password: 'password123'
      )
      expect(user.reload.email).to eq('test@example.com')
    end
  end

  describe 'password authentication' do
    it 'authenticates with correct password' do
      user = User.create!(name: 'beatrix', email: 'test@example.com', password: 'password123')
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      user = User.create!(name: 'beatrix', email: 'test@example.com', password: 'password123')
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end

  describe 'remember me functionality' do
    let(:user) { User.create!(name: 'beatrix', email: 'test@example.com', password: 'password123') }

    it 'creates a remember token and digest' do
      user.remember
      expect(user.remember_token).not_to be_nil
      expect(user.remember_digest).not_to be_nil
    end

    it 'authenticates with valid remember token' do
      user.remember
      expect(user.authenticated?(user.remember_token)).to be true
    end

    it 'does not authenticate with invalid remember token' do
      user.remember
      expect(user.authenticated?('invalid_token')).to be false
    end

    it 'does not authenticate when remember_digest is nil' do
      expect(user.authenticated?('any_token')).to be false
    end

    it 'forgets the user by clearing remember_digest' do
      user.remember
      user.forget
      expect(user.remember_digest).to be_nil
    end
  end
end

