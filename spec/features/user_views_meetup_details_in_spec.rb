require 'spec_helper'
require 'orderly'

feature "user views meetup details" do

  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let!(:meetup1) do
    Meetup.create(
    event_name: "Cars",
    time: "5:00PM",
    location: "20 Essex St",
    description: "Talk about cars",
    )
  end

  let!(:membership1) do
    Membership.create(
    user_id: "#{User.first.id}",
    creator: true,
    meetup_id: "#{Meetup.first.id}"
    )
  end

  scenario "sees details of meetup" do
    visit "/meetups"
    click_link("Cars")

    visit "/meetups/#{Meetup.first.id}"
    expect(page).to have_content("Cars")
    expect(page).to have_content("20 Essex St")
    expect(page).to have_content("Talk about cars")
    expect(page).to have_content("jarlax1")
  end
end
