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
%p{:class => "content"} Update application.js with your logic
%div{:class => "container", :id => "container"}
%div{:id => "testLogger"}
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
  %body{:class =>"yui3-skin-sam  yui-skin-sam"}
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

#testLogger {
    margin-bottom: 1em;
}

#testLogger .yui3-console .yui3-console-title {
    border: 0 none;
    color: #000;
    font-size: 13px;
    font-weight: bold;
    margin: 0;
    text-transform: none;
}
#testLogger .yui3-console .yui3-console-entry-meta {
    margin: 0;
}

.yui3-skin-sam .yui3-console-entry-pass .yui3-console-entry-cat {
    background: #070;
    color: #fff;
}

FILE
end

#----------------------------------------------------------------------------
# Initialize YUI and add YUI Test
#----------------------------------------------------------------------------
append_file 'public/javascripts/application.js' do <<-FILE
  
  YUI({ filter: 'raw' }).use("node", "console", "test",function (Y) {

      Y.namespace("example.test");

      Y.example.test.DataTestCase = new Y.Test.Case({

          //name of the test case - if not provided, one is auto-generated
          name : "Data Tests",

          //---------------------------------------------------------------------
          // setUp and tearDown methods - optional
          //---------------------------------------------------------------------

          /*
           * Sets up data that is needed by each test.
           */
          setUp : function () {
              this.data = {
                  name: "test",
                  year: 2007,
                  beta: true
              };
          },

          /*
           * Cleans up everything that was created by setUp().
           */
          tearDown : function () {
              delete this.data;
          },

          //---------------------------------------------------------------------
          // Test methods - names must begin with "test"
          //---------------------------------------------------------------------

          testName : function () {
              var Assert = Y.Assert;

              Assert.isObject(this.data);
              Assert.isString(this.data.name);
              Assert.areEqual("test", this.data.name);            
          },

          testYear : function () {
              var Assert = Y.Assert;

              Assert.isObject(this.data);
              Assert.isNumber(this.data.year);
              Assert.areEqual(2007, this.data.year);            
          },

          testBeta : function () {
              var Assert = Y.Assert;

              Assert.isObject(this.data);
              Assert.isBoolean(this.data.beta);
              Assert.isTrue(this.data.beta);
          }

      });

      Y.example.test.ArrayTestCase = new Y.Test.Case({

          //name of the test case - if not provided, one is auto-generated
          name : "Array Tests",

          //---------------------------------------------------------------------
          // setUp and tearDown methods - optional
          //---------------------------------------------------------------------

          /*
           * Sets up data that is needed by each test.
           */
          setUp : function () {
              this.data = [0,1,2,3,4]
          },

          /*
           * Cleans up everything that was created by setUp().
           */
          tearDown : function () {
              delete this.data;
          },

          //---------------------------------------------------------------------
          // Test methods - names must begin with "test"
          //---------------------------------------------------------------------

          testPop : function () {
              var Assert = Y.Assert;

              var value = this.data.pop();

              Assert.areEqual(4, this.data.length);
              Assert.areEqual(4, value);            
          },        

          testPush : function () {
              var Assert = Y.Assert;

              this.data.push(5);

              Assert.areEqual(6, this.data.length);
              Assert.areEqual(5, this.data[5]);            
          },

          testSplice : function () {
              var Assert = Y.Assert;

              this.data.splice(2, 1, 6, 7);

              Assert.areEqual(6, this.data.length);
              Assert.areEqual(6, this.data[2]);           
              Assert.areEqual(7, this.data[3]);           
          }

      });    

      Y.example.test.ExampleSuite = new Y.Test.Suite("Example Suite");
      Y.example.test.ExampleSuite.add(Y.example.test.DataTestCase);
      Y.example.test.ExampleSuite.add(Y.example.test.ArrayTestCase);

      //create the console
      var r = new Y.Console({
          newestOnTop : false,
          style: 'block' // to anchor in the example content
      });

      r.render('#testLogger');

      Y.Test.Runner.add(Y.example.test.ExampleSuite);

      //run the tests
      Y.Test.Runner.run();

  });

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
