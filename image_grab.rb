require 'watir'
require 'pry'
require 'nokogiri'
require 'open-uri'
require 'mimemagic'

# remove danger chars
search_term = ARGV[0] || 'hotdog'

browser = Watir::Browser.new(:chrome)

browser.goto 'images.google.com'
browser.text_fields.first.set search_term

browser.send_keys :enter

200.times{browser.send_keys :space ; sleep 0.01 }

doc = Nokogiri.parse(browser.html)

image_base_64 = []

image_urls = (doc.css 'img.rg_ic').map{|img|
  link = img.values.select{|v| /^http/ === v}.first 

  unless link
    image_base_64 << img.values.select{|v| /^data:image.*?base64/ === v}.first
  end

  link
}.compact


`mkdir "./images/#{search_term}/" `
image_urls.each_with_index do |url, index|
  download = open(url)
  type = MimeMagic.by_magic(download).subtype
  IO.copy_stream(download, "./images/#{search_term}/image_#{index}.#{type}")
end

image_base_64.each.with_index(image_urls.length) do |text, index|
  match = /data:image\/(?<type>.*?);base64,(?<data>.*)/.match(text)
  File.open("./images/#{search_term}/image_#{index}.#{match[:type]}", 'wb') do |f|
    f.write(  Base64.decode64(match[:data]))
  end
end

