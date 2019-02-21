require 'watir'
require 'pry'
require 'nokogiri'
require 'open-uri'
require 'mimemagic'


search_term = ARGV[0] || 'hotdog'

browser = Watir::Browser.new(:chrome)

browser.goto 'images.google.com'
browser.text_fields.first.set search_term

browser.send_keys :enter

doc = Nokogiri.parse(browser.html)

image_urls = (doc.css 'img.rg_ic').map{|img|  
  img.values.select{|v| /^http/ === v}.first 
}.compact

`mkdir "./images/#{search_term}/" `
image_urls.each_with_index do |url, index|
  download = open(url)
  type = MimeMagic.by_magic(download).subtype
  IO.copy_stream(download, "./images/#{search_term}/image_#{index}.#{type}")
end
