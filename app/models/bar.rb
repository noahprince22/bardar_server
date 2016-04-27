class Bar < ActiveRecord::Base
  acts_as_mappable

  has_many :reports do
    def current
      where(is_current: true).first
    end
  end

  def self.populate(cities, yelp = YelpHelper.build_from_yelp_config)
    cities.each do |city|
      yelp.get_bars(city).each do |bar|
        b = Bar.new(yelp_id: bar.id,
                    name: bar.name,
                    lat: bar.location.coordinate.latitude,
                    lng: bar.location.coordinate.longitude)
        b.save!
      end
    end
  end
end
