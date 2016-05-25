class UserReportValidator < ActiveModel::Validator
  def validate(record)
    created_at = record.created_at ? record.created_at : Time.now
    if record.user_id != "admin" and
        Report.where("created_at > ?", created_at - 15.minutes).where(user: record.user).count > 0
      record.errors[:base] << "Users cannot create a report for the same bar more than once in a 15 minute window"
    end
  end
end

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

  validates_inclusion_of :is_upvote, :in => [true, false]


  validates_with UserReportValidator

  after_create :_update_bar
  after_update :_update_bar

  def _update_bar
    self.bar.report_added(self)
  end

end
