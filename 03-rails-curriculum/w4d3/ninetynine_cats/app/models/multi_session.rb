
class MultiSession < ActiveRecord::Base

  def device_name
    start = self.device.index("(")
    finish = self.device.index(")")
    self.device[start..finish]
  end

  def location
    city = Geocoder.search(self.ip_address).first.city
    city.empty? ? "Local" : city
  end
end