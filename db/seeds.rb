require "faker"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#
#   Person.create(first_name: 'Eric', last_name: 'Kelly')
5.times do
  User.create(
    provider: "#{Faker::Company.name}",
    uid: "#{Faker::Number.digit}",
    username: "#{Faker::Name.name}",
    email: "#{Faker::Internet.email}",
    avatar_url: "#{Faker::Avatar.image}"
  )
end

5.times do
  Meetup.create(
  event_name: "#{Faker::Team.name}",
  time: "#{Faker::Time.between(DateTime.now - 1, DateTime.now)}",
  location: "#{Faker::Address.city}",
  description: "#{Faker::Hacker.say_something_smart}"
  )
end
#
meetups = Meetup.all
users = User.all

users.each do |user|
  meetups.each do |meetup|
    if user.id == meetup.id
      Membership.create(
      user_id: "#{user.id}",
      meetup_id: "#{meetup.id}",
      creator: "true")
    else
      Membership.create(
      user_id: "#{user.id}",
      meetup_id: "#{meetup.id}",
      creator: "false")
    end
  end
end
# 5.times do(
#   Membership.create(
#   user_id: "#{Faker::Number.between(1, 5)}",
#   meetup_id: "#{Faker::Number.between(1, 5)}",
#   )
# end
