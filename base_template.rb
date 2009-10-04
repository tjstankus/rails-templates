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
      = render 'shared/flash_messages'
      = yield :layout
END

file "app/views/shared/_flash_messages.html.haml", <<-END
- flash.each do |key, msg|
  = content_tag :div, msg, :id => "flash_#\{key\}"  
END

# Gems
gem('haml')
gem('rspec', :lib => false, :env => 'test')
gem('rspec-rails', :lib => false, :env => 'test')
gem('thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :env => 'test')
gem('cucumber', :env => 'test')
gem('webrat', :env => 'test')

# Generators
generate :rspec
generate :cucumber

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
