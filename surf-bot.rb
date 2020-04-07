require 'open-uri'
require 'nokogiri'
require 'envyable'
require 'twilio-ruby'

url ="https://www.surfline.com/surf-report/17th-st-/5842041f4e65fad6a77088eb"
page = Nokogiri::HTML(open(url))
status = page.css('div.quiver-colored-condition-bar').text


Envyable.load('./config/env.yml')

account_sid = ENV['TWILIO_ACCOUNT_SID']
auth_token = ENV['TWILIO_AUTH_TOKEN']
client = Twilio::REST::Client.new(account_sid, auth_token)


from = '+17144553380' # Your Twilio number
to = '+17149325629' # Your mobile phone number



client.messages.create(
from: from,
to: to,
body: status
)
