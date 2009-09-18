# TODO: Create function in bash profile similar to Railscast 148

run "echo TODO > README"
run "mv public/index.html public/index.orig.html"
run "rm -f public/javascripts/*"

file "app/views/layouts/application.html.haml", <<-END
!!! Strict
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
      
      - if show_title?
        %h1=h yield(:title)
      
      = yield

END

if yes?("Do you want to use jQuery?")
  version = ask("What version of jQuery? (Just enter for 1.3.2)")
  jquery_version = version.empty? ? "1.3.2" : version
  run "curl -L http://jqueryjs.googlecode.com/files/jquery-#{jquery_version}.min.js > public/javascripts/jquery-#{jquery_version}.min.js"
end

run "curl -L http://yui.yahooapis.com/2.8.0r4/build/reset/reset-min.css > public/stylesheets/reset-min.css"

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "cp config/database.yml config/database_example.yml"

gem('haml')

# Testing tools
gem('rspec', :lib => false, :env => 'test')
gem('rspec-rails', :lib => false, :env => 'test')
gem('thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :env => 'test')
gem('cucumber', :env => 'test')
gem('webrat', :env => 'test')

# rake('gems:install', :sudo => true)

generate :rspec
generate :cucumber

git :init
git :add => '.'
git :commit => "-m 'Initial commit.'"
