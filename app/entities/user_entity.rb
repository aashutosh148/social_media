class UserEntity < Grape::Entity
  expose :id
  expose :username
  expose :email
  expose :bio
  expose :avatar_url, if: { type: :full }
  expose :created_at, format_with: :iso8601
  expose :updated_at, format_with: :iso8601
  format_with(:iso8601) { |dt| dt&.iso8601 }
end
    