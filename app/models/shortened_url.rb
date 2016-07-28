class ShortenedUrl < ActiveRecord::Base
  validates :short_url, :long_url, presence: true, uniqueness: true
  validate :url_length
  validate :less_than_5_in_last_minute
  validate :non_premium_limit

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Visit

  has_many :visitors,
    -> { distinct }, #same as Proc.new
    through: :visits,
    source: :visitor

  has_many :taggings,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Tagging

  has_many :tags,
    -> { distinct },
    through: :taggings,
    source: :tag

  def url_length
    unless self.long_url.length < 1024
      self.errors[:long_url] << "must be shorter than 1024 characters"
    end
  end

  def non_premium_limit
    unless self.submitter.premium
      cur_submitter = self.submitter
      all_urls_from_submitter = ShortenedUrl.all.select { |u| u.submitter == cur_submitter}
      unless all_urls_from_submitter.count < 6
        self.errors[:User] << "must be premium to create more than 5 urls."
      end
    end
  end

  def less_than_5_in_last_minute
    cur_submitter = self.submitter
    all_urls_from_submitter = ShortenedUrl.all.select { |u| u.submitter == cur_submitter}
    last_min_urls = all_urls_from_submitter.select { |u| u.created_at > 1.minutes.ago}
    unless last_min_urls.count < 5
      self.errors[:User] << "has submitted too many urls in the last minute"
    end
  end

  def self.random_code
    new_code = SecureRandom::urlsafe_base64
    while self.exists?(short_url: new_code)
      new_code = SecureRandom::urlsafe_base64
    end
    new_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create!(short_url: short_url, long_url: long_url, user_id: user.id)
    short_url
  end

  def self.prune
    stale_urls = ShortenedUrl.all.select { |u| u.created_at < 60.minutes.ago && (u.visits.last.nil? || u.visits.last.created_at < 60.minutes.ago) }
    stale_urls.each { |u| u.destroy }
  end

  def num_clicks
     clicks = Visit.all.select { |v| self.id == v.shortened_url_id }
     clicks.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    recent_visits = visits.select(:user_id).where("created_at > :time", {time: 10.minutes.ago})
    recent_visits.distinct.count
  end

end
