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

    # Reports that aren't the current report and are newer than a day
    def recent
      where.not(is_current: true).where("created_at > ?", DateTime.now - 1)
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
              is_upvote: false,
              is_current: true,
              user_id: "admin"
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
    recent_reports = self.reports.recent

    if recent_reports.count > 0
      # normal for everything, with arbitrary varying times.
      #  TODO: adjust these time spans based on actual data.
      current = self.reports.current
      current.line_length = Heuristic.normal_on_models_attribute(recent_reports, :line_length, 10)
      current.cover_charge = Heuristic.normal_on_models_attribute(recent_reports, :cover_charge, 10)
      current.ratio = Heuristic.normal_on_models_attribute(recent_reports, :ratio, 30)
      current.avg_age = Heuristic.normal_on_models_attribute(recent_reports, :avg_age, 30)
      current.crowd = Heuristic.normal_on_models_attribute(recent_reports, :crowd, 15)

      current.save!
    end
  end

  # Function of when it was last updated
  #   Use normal over a 60 minute period, so an hour later will be 3ish on freshness scale. 2 hours down to 2ish
  #   Falls steeply linearly at first, leveling off. Any more than 2 hours has low validity
  # 0: 9.999999924644236
  # 10: 8.67632331718106
  # 20: 7.388826782669538
  # 30: 6.170750760828307
  # 40: 5.049850738515479
  # 50: 4.04656760830962
  # 60: 3.173105070563451
  # 70: 2.433450082509907
  # 80: 1.8242243881391906
  # 90: 1.3361440210599085
  # 100: 0.9558070415877362
  # 110: 0.6675301488064678
  # 120: 0.4550026371638849
  # 130: 0.30260279893296715
  # 140: 0.19630657155316977
  def freshness
    # 15.times do |i|
    #   puts "#{i}: #{10*Heuristic.p_value({ time: Time.now - (i*10).minutes }, 60)}"
    # end

    return 10*Heuristic.p_value({ time: self.updated_at }, 60)
  end
end
