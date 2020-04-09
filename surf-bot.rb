# Required gems for this script
require 'open-uri'
require 'nokogiri'
require 'envyable'
require 'twilio-ruby'

# Nokogiri for web scraping
url = "https://www.surfline.com/surf-report/17th-st-/5842041f4e65fad6a77088eb"
page = Nokogiri::HTML(open(url))

# Scraped data set into variables
status = page.css('div.quiver-colored-condition-bar').text
height = page.css('div.quiver-spot-forecast-summary__stat-container--surf-height > span.quiver-surf-height').text
tide = page.css('div.quiver-spot-forecast-summary__stat-container--tide > div.quiver-conditions-stats__stat-reading > span.quiver-reading').text
next_tide = page.css('div.quiver-spot-forecast-summary__stat-container--tide > span.quiver-reading-description').text
temp = page.css('div.quiver-water-temp > div').text

# This is how you load Envyable to hide config vars
Envyable.load('./config/env.yml')

account_sid = ENV['TWILIO_ACCOUNT_SID']
auth_token = ENV['TWILIO_AUTH_TOKEN']

# Twilio code from gem create new client from config vars
client = Twilio::REST::Client.new(account_sid, auth_token)

from = '+17144553380' # Your Twilio number
to = '+17149325629' # Your mobile phone number

# Create message layout for the text
message = "\n GOOD MORNING HANDSOME!! It's #{status}!\n
					 \n Surf Height: #{height}\n
					 \n Tide: #{tide}\n 
					 \n #{next_tide}\n 
					 \n Water Temp: #{temp}"

puts message

# Send the text only if it's good or fair
if (status.include?("FAIR") || status.include?("GOOD"))
	client.messages.create(
			from: from,
			to: to,
			body: message
		)
end




=begin

NOTES:



=end
