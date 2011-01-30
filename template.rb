# YUI3 Application Generator Template
# Generates a Rails app; includes YUI3, Haml, RSpec, Cucumber, WebRat, Factory Girl ...

puts "Generating a new YUI3 Rails app"

#----------------------------------------------------------------------------
# Create the database
#----------------------------------------------------------------------------
puts "creating the database..."
run 'rake db:create:all'

#----------------------------------------------------------------------------
# GIT
#----------------------------------------------------------------------------
puts "setting up 'git'"

append_file '.gitignore' do <<-FILE
'.DS_Store'
'.rvmrc'
FILE
end
git :init
git :add => '.'
git :commit => "-m 'Initial Commit of YUI3 Rails App'"

#----------------------------------------------------------------------------
# Remove files
#----------------------------------------------------------------------------
puts "removing files..."
run 'rm public/index.html'
run 'rm public/favicon.ico'
run 'rm public/images/rails.png'
run 'rm README'
run 'touch README'

puts "banning spiders from your site by changing robots.txt..."
gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'

#----------------------------------------------------------------------------
# Haml 
#----------------------------------------------------------------------------
  puts "setting up Gemfile for Haml..."
  append_file 'Gemfile', "\n# Bundle gems needed for Haml\n"
  gem 'haml', '3.0.18'
  gem 'haml-rails', '0.2', :group => :development

#----------------------------------------------------------------------------
# Set up YUI3
#----------------------------------------------------------------------------

puts "replacing Prototype with YUI3"
run 'rm public/javascripts/controls.js'
run 'rm public/javascripts/dragdrop.js'
run 'rm public/javascripts/effects.js'
run 'rm public/javascripts/prototype.js'
run 'rm public/javascripts/rails.js'

get "http://yui.yahooapis.com/combo?3.3.0/build/yui/yui-debug.js",  "public/javascripts/yui-debug.js"
get "http://yui.yahooapis.com/3.3.0/build/cssreset/reset.css",  "public/stylesheets/reset.css"
get "http://yui.yahooapis.com/3.3.0/build/cssbase/base.css",  "public/stylesheets/base.css"
get "http://yui.yahooapis.com/3.3.0/build/cssfonts/fonts.css",  "public/stylesheets/fonts.css"
get "http://yui.yahooapis.com/3.3.0/build/cssgrids/grids.css",  "public/stylesheets/grids.css"

#----------------------------------------------------------------------------
# Create an index page
#----------------------------------------------------------------------------
puts "create a home controller and view"
generate(:controller, "home index")
gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'
append_file 'app/views/home/index.html.haml'do <<-FILE
!!!
%h2{:class => "subtitle"} Get Started
%p{}:class => "content"} Update with application.js with your logic
%div{:class => "container", :id => "container"} 
FILE
end

#----------------------------------------------------------------------------
# Generate Application Layout
#----------------------------------------------------------------------------

run 'rm app/views/layouts/application.html.erb'
  create_file 'app/views/layouts/application.html.haml' do <<-FILE
!!!
%html
  %head
    %title YUI3 App
    = stylesheet_link_tag "reset"
    = stylesheet_link_tag "base"
    = stylesheet_link_tag "fonts"
    = stylesheet_link_tag "grids"
    = stylesheet_link_tag "application"
    = javascript_include_tag :all
    = csrf_meta_tag
  %body
    = yield
FILE
end

#----------------------------------------------------------------------------
# Add Stylesheets
#----------------------------------------------------------------------------
create_file 'public/stylesheets/application.css' do <<-FILE
div.container {
  width: 100%;
  height: 100px; 
  padding: 10px;
  margin: 10px;
  border: 1px solid red;
}
FILE
end

#----------------------------------------------------------------------------
# Setup RSpec & Cucumber
#----------------------------------------------------------------------------
puts 'Setting up RSpec, Cucumber, webrat, factory_girl, faker'
append_file 'Gemfile' do <<-FILE
group :development, :test do
  gem "rspec-rails", ">= 2.0.1"
  gem "cucumber-rails", ">= 0.3.2"
  gem "webrat", ">= 0.7.2.beta.2"
  gem "factory_girl_rails"
  gem "faker"
end
FILE
end

run 'bundle install'
run 'script/rails generate rspec:install'
run 'script/rails generate cucumber:install'
run 'rake db:migrate'
run 'rake db:test:prepare'

run 'touch spec/factories.rb'
#----------------------------------------------------------------------------
# Finish up
#----------------------------------------------------------------------------
puts "Commiting to Git repository..."
git :add => '.'
git :commit => "-am 'Setup Complete'"

puts "DONE - setting up your YUI3 Rails App."
