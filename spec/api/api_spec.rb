require 'rails_helper'

RSpec.describe API do
  it 'returns the upcoming holidays' do
    uri = URI('https://date.nager.at/api/v2/NextPublicHolidays/us')
    res = Net::HTTP.get(uri)
    expect(res).to be_instance_of(String)
    JSON.parse(res).each do |r|
      expect(r).to have_key('date')
      expect(r).to have_key('localName')
    end
  end
end