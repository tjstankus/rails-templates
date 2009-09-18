# TODO: Create function in bash profile similar to Railscast 148

# General file cleanup
run "echo TODO > README"
run "mv public/index.html public/index.orig.html"
run "rm -f public/javascripts/*"
run "cp config/database.yml config/database_example.yml"

# YUI reset.css
run "curl -L http://yui.yahooapis.com/2.8.0r4/build/reset/reset-min.css > public/stylesheets/reset-min.css"

# jQuery
if yes?("Do you want to use jQuery?")
  jquery_version = ask("What version of jQuery? (Just enter for 1.3.2)")
  jquery_filename = jquery_version.empty? ? "jquery-1.3.2.min.js" : "jquery-#{jquery_version}.min.js"
  jquery_dest = "public/javascripts/#{jquery_filename}"
  run "curl -L http://jqueryjs.googlecode.com/files/#{jquery_filename} > #{jquery_dest}"
end

# Application layout with HAML
# TODO: Get jQuery in there if it's being used.
file "app/views/layouts/application.html.haml", <<-END
!!!
%html{html_attrs}
  
  %head
    %title
      = h(yield(:title) || "Untitled")
    %meta{"http-equiv"=>"Content-Type", :content=>"text/html; charset=utf-8"}/
    = stylesheet_link_tag 'reset-min'
    = yield(:head)
  
  %body
    #container
      - flash.each do |name, msg|
        = content_tag :div, msg, :id => "flash_#\{name\}"
      
      = yield
END

# .gitignore
file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

# Gems
gem('haml')
gem('rspec', :lib => false, :env => 'test')
gem('rspec-rails', :lib => false, :env => 'test')
gem('thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :env => 'test')
gem('cucumber', :env => 'test')
gem('webrat', :env => 'test')

# rake('gems:install', :sudo => true)

# Generators
generate :rspec
generate :cucumber

# Git'r done
git :init
git :add => '.'
git :commit => "-m 'Initial commit.'"
