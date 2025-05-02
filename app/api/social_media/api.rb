require 'grape_logging'
require 'colorize'

module SocialMedia
  class GrapeColoredLogger
    def call(request, response)
      method = request.request_method.colorize(:light_blue)
      path   = request.path.colorize(:cyan)
      status = response[0]

      color = if status >= 500
                :red
              elsif status >= 400
                :yellow
              else
                :green
              end

      status_colored = status.to_s.colorize(color)

      "[#{method}] #{path} => #{status_colored}"
    end
  end

  class Api < Grape::API
    use GrapeLogging::Middleware::RequestLogger,
        logger: Rails.logger,
        loggers: [
          GrapeLogging::Loggers::FilterParameters.new,
          SocialMedia::GrapeColoredLogger.new
        ]

    prefix :api
    # format :json

    mount SocialMedia::V1::Base
  end
end
