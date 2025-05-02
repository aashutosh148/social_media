require 'rails_helper'

RSpec.describe "API::V1::Users", type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for(user) }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  # Helper method to generate token
  def generate_token_for(user)
    JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
  end

  describe "GET /api/v1/users/:id" do
    it "returns the user" do
      get "/api/v1/users/#{user.id}", headers: headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['username']).to eq(user.username)
    end

    it "returns not found for non-existent user" do
      get "/api/v1/users/0", headers: headers
      
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /api/v1/users/:id/followers" do
    let!(:follower1) { create(:user) }
    let!(:follower2) { create(:user) }
    
    before do
      create(:follow, follower: follower1, following: user)
      create(:follow, follower: follower2, following: user)
    end

    it "returns the user's followers" do
      get "/api/v1/users/#{user.id}/followers", headers: headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      follower_ids = json_response.map { |f| f['id'] }
      expect(follower_ids).to include(follower1.id, follower2.id)
    end
  end

  describe "GET /api/v1/users/:id/following" do
    let!(:following1) { create(:user) }
    let!(:following2) { create(:user) }
    
    before do
      create(:follow, follower: user, following: following1)
      create(:follow, follower: user, following: following2)
    end

    it "returns the users followed by the user" do
      get "/api/v1/users/#{user.id}/following", headers: headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      following_ids = json_response.map { |f| f['id'] }
      expect(following_ids).to include(following1.id, following2.id)
    end
  end

  describe "POST /api/v1/users/:id/follow" do
    let(:user_to_follow) { create(:user) }

    it "follows another user" do
      expect {
        post "/api/v1/users/#{user_to_follow.id}/follow", headers: headers
      }.to change { user.following.count }.by(1)
      
      expect(response).to have_http_status(:created)
      expect(user.following).to include(user_to_follow)
    end

    it "returns error if already following" do
      create(:follow, follower: user, following: user_to_follow)
      
      expect {
        post "/api/v1/users/#{user_to_follow.id}/follow", headers: headers
      }.not_to change { user.following.count }
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/v1/users/:id/follow" do
    let(:followed_user) { create(:user) }

    before do
      create(:follow, follower: user, following: followed_user)
    end

    it "unfollows a user" do
      expect {
        delete "/api/v1/users/#{followed_user.id}/follow", headers: headers
      }.to change { user.following.count }.by(-1)
      
      expect(response).to have_http_status(:ok)
      expect(user.following).not_to include(followed_user)
    end
  end
end