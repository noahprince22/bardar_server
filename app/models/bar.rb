class Bar < ActiveRecord::Base
  reverse_geocoded_by(:latitude,
                      :longitude)
  #after_validation :reverse_geocode  # auto-fetch address

  validates :yelp_id, presence: true, uniqueness: true

  after_create :set_default_current

  has_many :reports do
    def current
      where(is_current: true).first
    end
  end

  def set_default_current
    Report.create(
              bar_id: id,
              line_length: 0,
              cover_charge: 0,
              ratio: 0.5,
              avg_age: 25,
              crowd: 0,
              is_current: true
    )
  end

  def self.populate(cities, yelp = YelpHelper.build_from_yelp_config)
    cities.each do |city|
      yelp.get_bars(city).each do |bar|
        if (!Bar.exists?(yelp_id: bar.id, name: bar.name))
          b = Bar.new(yelp_id: bar.id,
                      name: bar.name,
                      latitude: bar.location.coordinate.latitude,
                      longitude: bar.location.coordinate.longitude)
          b.save!
        end
      end
    end
  end

  def update_current_stats

  end
end
