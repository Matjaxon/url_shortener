# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

20.times do
  User.create!(email: Faker::Internet.email, premium: true)
  User.create!(email: Faker::Internet.email, premium: false)
end

all_users = User.all

60.times do
  ShortenedUrl.create_for_user_and_long_url!(all_users.sample, Faker::Internet.url)
end

all_shortened_urls = ShortenedUrl.all

300.times do
  Visit.record_visit!(all_users.sample, all_shortened_urls.sample)
end
