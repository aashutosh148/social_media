require 'rails_helper'

RSpec.describe "API::V1::Auth", type: :request do
  describe "POST /api/v1/auth/signup" do
    let(:valid_attributes) {
      {
        username: "testuser",
        email: "test@example.com"
      }
    }

    context "with valid parameters" do
      let(:fair_attributes) { valid_attributes.merge(password: "password123") }

      it "creates a new user" do
        expect {
          post "/api/v1/auth/signup", params: fair_attributes
        }.to change(User, :count).by(1)
      end

      it "returns a success response with token" do
        post "/api/v1/auth/signup", params: fair_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("token")
      end
    end

    context "with invalid parameters" do
      it "does not create a new user with duplicate email" do
        create(:user, email: "test@example.com", password: "password123")
        
        expect {
          post "/api/v1/auth/signup", params: valid_attributes.merge(password: "password123")
        }.not_to change(User, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a new user with password with size less than 6" do
        invalid_attributes = valid_attributes.merge(password: "six")
        
        expect {
          post "/api/v1/auth/signup", params: invalid_attributes
        }.not_to change(User, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "POST /api/v1/auth/login" do
    let!(:user) { create(:user, email: "test@example.com", password: "password123") }
    
    context "with valid credentials" do
      it "returns a success response with token" do
        post "/api/v1/auth/login", params: { email: "test@example.com", password: "password123" }
        
        expect(response).to have_http_status(:created) 
        expect(JSON.parse(response.body)).to include("token")
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized status" do
        post "/api/v1/auth/login", params: { email: "test@example.com", password: "wrongpassword" }
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end