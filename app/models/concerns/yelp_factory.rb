module YelpFactory
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