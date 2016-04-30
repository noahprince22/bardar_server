if (Rails.env.downcase != "test")
  Bar.populate(["Champaign", "Effingham"])

  scheduler = Rufus::Scheduler.new
  scheduler.every("1d") do
    Bar.populate(["Champaign", "Effingham"])
  end
end