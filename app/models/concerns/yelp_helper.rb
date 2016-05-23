module YelpBuilder
  def self.from_yelp_config(yelp_config_path = Rails.root.join('config/yelp.yml'))
    config = YAML.load_file(yelp_config_path)
    return Yelp::Client.new({
                         consumer_key: config["consumer_key"],
                         consumer_secret: config["consumer_secret"],
                         token: config["token"],
                         token_secret: config["token_secret"]
                     })
  end
end

class YelpHelper
  # @param [Yelp::Client] yelp_client
  def initialize(yelp_client)
    @yelp = yelp_client
  end

  def get_bars(location)
    bars = []

    category = 'nightlife'
    result = @yelp.search(location, {
        category_filter: category
    })

    total = result.total
    bars = bars.concat(result.businesses)

    num_20_sets = (total.to_f / 20).ceil
    num_20_sets = 50 if num_20_sets > 50

    num_20_sets.times do |i|
      next if i == 0 # we aleady got the first result, so ignore.
      bars.concat(
              @yelp.search(location, {
                  category_filter: category,
                  offset: i*20
              }).businesses
      )
    end

    return bars
  end
end
