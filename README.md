# image_GG
image grabber from google images


# Setup instructions

install ruby (I used version `2.5.3p105` ) but it shouldn't make a difference

install the following gems:

 - watir
 - pry
 - nokogiri
 - open'
 - mimemagic


 ### Download the chrome web driver and put it in your path.
This link should help:
http://watir.com/guides/drivers/

run the image grab script with a search term as the first argument
eg `image_grab.rb 'cat in a hat'`

It should open an instance of chrome and start downloading pictures to the /images/#{search_term} directory
