# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  long_url   :string           not null
#  short_url  :string
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :long_url, :user_id, presence: true
  validates :short_url, presence: true, uniqueness: true

  belongs_to(
    :submitter,
    class_name: "User",
    primary_key: :id,
    foreign_key: :user_id
  )

  has_many(
    :visits,
    class_name: "Visit",
    primary_key: :id,
    foreign_key: :shortened_url_id
  )

  has_many(
    :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor
  )

  def self.random_code
    SecureRandom.urlsafe_base64
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short = random_code
    while exists?(short_url: short)
      short = random_code
    end
    create(short_url: short, long_url: long_url, user_id: user)
  end


  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visits.where(updated_at: 10.minutes.ago..Time.now).select(:user_id).distinct.count
    #Check this
  end

end
