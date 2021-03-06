# encoding utf-8
require File.join(File.dirname(__FILE__), 'toto')

require 'coderay'
require 'rack/codehighlighter'
use Rack::Codehighlighter, :coderay, :line_numbers => 'inline', :markdown => true, :element => "pre>code", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => true, :line_numbers => 'inline'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico', '/sitemap.xml'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  # 
  # set :author,    ENV['USER']                               # blog author
  set :title,     'Code It Terron'                   # site title
  # set :root,      "index"                                   # page to load on /
  # set :date,      lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
  set :markdown,  true                                    # use markdown + smart-mode
  set :disqus,    'codeitterron'                                     # disqus id, or false
  # set :summary,   :max => 150, :delim => /~/                # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds

  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
end

run toto