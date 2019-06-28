require 'mimemagic'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'watir'
require 'webdrivers/chromedriver'

# remove danger chars
search_term = ARGV[0] || 'hotdog'

puts 'Starting Selenium...'

Webdrivers::Chromedriver.update
browser = Watir::Browser.new :chrome

num_images = ARGV[1].to_i || 10

pages = 1 + (num_images / 400).floor

browser.goto 'images.google.com'
browser.text_fields.first.set search_term

browser.send_keys :enter

puts 'Loading images...'

pages.times do
  400.times do |_|
    browser.send_keys :space
    sleep 0.01
  end

  browser.button(value: 'Show more results').click if browser.button(value: 'Show more results').present?
end

puts 'Images loaded'

doc = Nokogiri.parse(browser.html)

image_base_64 = []
image_urls = []

total_images = 0

puts 'Fetching URLS...'

(doc.css 'img.rg_ic').each do |img|
  if total_images > num_images
    puts 'break'
    break
  end
  link = img.values.select { |v| /^http/ === v }.first

  unless link
    image_base_64 << img.values.select { |v| /^data:image.*?base64/ === v }.first
  end

  image_urls << link
  total_images += 1
end

image_urls.compact!

puts "#{image_urls.length} URLs fetched"

`mkdir "./images"`
`mkdir "./images/#{search_term}/" `
image_urls.each_with_index do |url, index|
  download = open(url)
  type = MimeMagic.by_magic(download).subtype
  file_match = "./images/#{search_term}/image_#{index}.#{type}"
  IO.copy_stream(download, file_match)
  puts "image saved: #{file_match}"
end

image_base_64.each.with_index(image_urls.length) do |text, index|
  match = /data:image\/(?<type>.*?);base64,(?<data>.*)/.match(text)
  file_match = "./images/#{search_term}/image_#{index}.#{match[:type]}"
  File.open(file_match, 'wb') do |f|
    f.write(Base64.decode64(match[:data]))
  end
  puts "image saved: #{file_match}"
end
