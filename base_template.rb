# General file cleanup
run "echo TODO > README"
run "mv public/index.html public/index.orig.html"
run "rm -f public/javascripts/*"
run "cp config/database.yml config/database_example.yml"


# jQuery
# if yes?("Do you want to use jQuery?")
#   jquery_version = ask("What version of jQuery? (Just enter for 1.3.2)")
#   jquery_filename = jquery_version.empty? ? "jquery-1.3.2.min.js" : "jquery-#{jquery_version}.min.js"
#   jquery_dest = "public/javascripts/#{jquery_filename}"
#   run "curl -L http://jqueryjs.googlecode.com/files/#{jquery_filename} > #{jquery_dest}"
# end
jquery_filename = "jquery-1.3.2.min.js"
jquery_dest = "public/javascripts/#{jquery_filename}"
run "curl -L http://jqueryjs.googlecode.com/files/#{jquery_filename} > #{jquery_dest}"


# Compass
# css_framework = ask("What CSS Framework do you want to use with Compass? (default: 'blueprint')")
# css_framework = "blueprint" if css_framework.blank?
sass_dir = ask("Where would you like to keep your sass files within your project? (default: 'app/stylesheets')")
sass_dir = "app/stylesheets" if sass_dir.blank?
css_dir = ask("Where would you like Compass to store your compiled css files? (default: 'public/stylesheets/compiled')")
css_dir = "public/stylesheets/compiled" if css_dir.blank?
compass_command = "compass --rails -f blueprint . --css-dir=#{css_dir} --sass-dir=#{sass_dir} "
run compass_command


# Require compass during plugin loading
file 'vendor/plugins/compass/init.rb', <<-CODE
# This is here to make sure that the right version of sass gets loaded (haml 2.2) by the compass requires.
require 'compass'
CODE


# Application layout with HAML
file "app/views/layouts/application.html.haml", <<-END
!!!
%html{html_attrs}

  %head
    %title
      = h(yield(:title) || "Untitled")
    %meta{"http-equiv"=>"Content-Type", :content=>"text/html; charset=utf-8"}/
    = javascript_include_tag 'jquery-1.3.2.min.js'
    = stylesheet_link_tag 'compiled/screen', 'compiled/print'
    = yield(:head)

  %body.bp
    #container
      = render 'shared/flash_messages'
      = yield :layout

END

file "app/views/shared/_flash_messages.html.haml", <<-END
- flash.each do |key, msg|
  = content_tag :div, msg, :class => "flash #\{key\}"

END

append_file "#{sass_dir}/screen.sass", <<-END

.flash
  margin: 0 0 10px 0
  padding: 10px

.flash.notice
  border: 1px solid #256e2c
  background-color: #a4e7a0

.flash.error
  border: 1px solid #900
  background-color: #e8a3a3

END


# Gems
gem('haml')
gem('compass', :version => '>= 0.8.17')
gem('rspec', :lib => false, :env => 'test')
gem('rspec-rails', :lib => false, :env => 'test')
gem('factory_girl', :env => 'test')
gem('cucumber', :env => 'test')
gem('cucumber-rails', :env => 'test')
gem('webrat', :env => 'test')
gem('pickle', :env => 'test')


# Generators
generate :rspec
generate :cucumber
generate :pickle, 'paths email'


# .gitignore
file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"


# Git'r done
git :init
git :add => '.'
git :commit => "-m 'Initial commit.'"
