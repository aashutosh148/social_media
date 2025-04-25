module SocialMedia
  class Api < Grape::API
    prefix :api
    format :json
    
    mount SocialMedia::V1::Base
  end
end 