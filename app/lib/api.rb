class API
  def self.get_next_holidays
    res = Faraday.get('https://date.nager.at/api/v2/NextPublicHolidays/us')
    JSON.parse(res.body)
  end
end
