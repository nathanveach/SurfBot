require 'open-uri'
require 'nokogiri'
require 'envyable'
require 'twilio-ruby'

url = "https://www.surfline.com/surf-report/17th-st-/5842041f4e65fad6a77088eb"
page = Nokogiri::HTML(open(url))

status = page.css('div.quiver-colored-condition-bar').text
height = page.css('div.quiver-spot-forecast-summary__stat-container--surf-height').text
tide = page.css('div.quiver-spot-forecast-summary__stat-container--tide').text
wind = page.css('div.quiver-spot-forecast-summary__stat-container--surf-height').text
temp = page.css('div.quiver-water-temp').text

Envyable.load('./config/env.yml')

account_sid = ENV['TWILIO_ACCOUNT_SID']
auth_token = ENV['TWILIO_AUTH_TOKEN']
client = Twilio::REST::Client.new(account_sid, auth_token)


from = '+17144553380' # Your Twilio number
to = '+17149325629' # Your mobile phone number




if (status.include?("FAIR") || status.include?("GOOD"))
	client.messages.create(
		from: from,
		to: to,
		body: "\n#{status}\n \n#{height}\n \n#{tide}\n \n#{wind}\n \n#{temp}"
	)
end

if status.include?("POOR") && !(status.include?("FAIR"))
	client.messages.create(
		from: from,
		to: to,
		body: "Sleep in, it suckssssssss"
	)
end
