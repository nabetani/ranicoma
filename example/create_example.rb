# frozen_string_literal: true

require "ranicoma"
require "fileutils"
require 'rexml/document'
require 'rexml/formatters/pretty'

HERE = File.split(__FILE__)[0]
DIRNAME="icons"
ICONS_DIR = File.join(HERE, DIRNAME)

def main
  FileUtils.mkdir_p( ICONS_DIR )
  s=[]
  formatter = REXML::Formatters::Pretty.new
  100.times do |ix|
    body = "#{ix}.svg"
    s.push( File.join(DIRNAME, body) )
    File.open( File.join(ICONS_DIR, body), "w" ) do |f|
      c=Ranicoma::Creator.new(ix, 100)
      formatter.write(c.create, f)
    end
  end
  File.open( File.join(HERE, "index.html"), "w" ) do |f|
    f.puts <<~HTML_HEAD
      <!DOCTYPE html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta http-equiv="Content-Language" content="ja-JP">
        <style>
          img{ padding: 4px 4px 4px 4px; }
        </style>
      </head>
    HTML_HEAD
    s.each do |e|
      f.puts( "<img src='#{e}'/>" )
    end
  end
end

main

