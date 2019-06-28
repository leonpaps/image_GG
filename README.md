# image_GG
Image grabber from google images


# Setup instructions

Install ruby (I used version `2.5.3p105` ) but it shouldn't make a difference

Run the following command to install the required gems:

`gem install watir pry nokogiri mimemagic webdrivers`

run the image grab script with a search term as the first argument and the number of images as the second term
eg `image_grab.rb 'cat in a hat' 10`

It should open an instance of chrome and start downloading pictures to the /images/#{search_term} directory


# Disclaimer:
I made this for fun, I am not responsible for the content it fetches nor claim ownership of said content.
Use responsibly!
