require 'watir'
require 'pry'
require 'nokogiri'
require 'open-uri'


browser = Watir::Browser.new(:chrome)

browser.goto 'images.google.com'
browser.text_fields.first.set 'hotdog'

sleep 1

browser.send_keys :enter

sleep 1

doc = Nokogiri.parse(browser.html)

image_urls = (doc.css 'img.rg_ic').map{|img|  
                img.values.select{|v| /^http/ === v}.first 
              }.compact


image_urls.each_with_index do |url, index|
  download = open(url)

  IO.copy_stream(download, "./images/image_#{index}")
end

