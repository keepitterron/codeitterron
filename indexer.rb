#!/usr/bin/env ruby
require 'rubygems'
require 'ferret'
require 'find'
include Ferret

require 'toto'
@config = Toto::Config::Defaults
search_path = "#{Toto::Paths[:articles]}/"
ferret_path = "#{Toto::Paths[:articles]}/f/"

wot = ARGV[0]
if wot.nil?
 puts "use: search.rb <query>"
 exit
end

index = Index::Index.new(:default_field => 'content', :path => './y.idx')

ini = Time.now
numFiles=0

Find.find(search_path) do |path|
 puts "Indexing: #{path}"
 numFiles=numFiles+1
 if FileTest.file? path
 	File.open(path) do |file|
 	
 		meta, body = file.read.split(/\n\n/, 2)
 		o = YAML::load(meta)
 		index.add_document(:file => path, :content => body, :title => o['title'])
 	end
 end
end

docs=0

# uncomment line below for 10 first results, and comment the subsequent line.
# index.search_each(wot) do |doc, score| 

index.search_each(wot, options={:limit=>:all}) do |doc, score|
 puts index[doc]['file'] + " score: "+score.to_s
 docs+=1
end


elapsed = Time.now - ini
puts "Files: #{numFiles}"
puts "Docs: #{docs}"
puts "Elapsed time: #{elapsed} secs\n"