# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks


# lib/tasks/grape_routes.rake

# Check if the API constant is defined to avoid errors if Grape isn't loaded
if defined?(API::Root)
  namespace :grape do
    desc "Print out routes defined in the Grape API (API::Root)" # Use the desc method for the description
    task :routes => :environment do
      puts "Grape API Routes (from API::Root):"
      puts "------------------------------------"
      API::Root.routes.each do |route|
        info = route.instance_variable_get(:@options)
        # Safely access description, method, and path, providing defaults if nil
        description = info[:description] ? "#{info[:description][0..39]}..." : "[No description]"
        method = info[:method] ? info[:method].to_s.upcase : "[No method]"
        path = info[:path] ? info[:path].to_s : "[No path]"

        # Ensure consistent spacing
        printf "%-45s %-8s %s\n", description, method, path
      end
      puts "------------------------------------"
    end
  end
else
  # Optionally, define a dummy task or print a warning if API::Root isn't found
  namespace :grape do
    desc "Grape API not detected - cannot print routes"
    task :routes do
      puts "Warning: API::Root constant not found. Cannot list Grape routes."
      puts "Ensure your Grape API is loaded correctly."
    end
  end
end