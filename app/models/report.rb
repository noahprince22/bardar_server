class Report < ActiveRecord::Base
  belongs_to :bar
  belongs_to :user
  validates :bar_id,
            :line_length,
            :cover_charge,
            :ratio,
            :avg_age,
            :crowd,
            presence: true
  after_create :update_bar_current

  def update_bar_current
    # Naive, current is just the most recent
    current = self.bar.reports.current

    # Only do stuff if current is defined. If not defined,
    #  the thing we're creating is the current record
    if (current)
      self.bar.update_current_stats

      # current.update(self.attributes.slice(:user_id))
      # current.is_current = false
      # current.save!
      #
      # self.is_current = true
      # self.save
    end
  end

end
