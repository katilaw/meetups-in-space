require 'spec_helper'
require 'orderly'

feature "user views list of meetups" do

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
      event_name: "Tech Talk",
      time: "7:00PM",
      location: "33 Harrison Ave",
      description: "Talk about tech"
    )
  end

  let!(:meetup2) do
    Meetup.create(
    event_name: "Cars",
    time: "5:00PM",
    location: "20 Essex St",
    description: "Talk about cars",
    )
  end


 scenario "sees meetups" do
   visit "/meetups"
   expect(page).to have_content("Cars")
   expect(page).to have_content("Tech Talk")
   expect("Cars").to appear_before("Tech Talk")
 end
end
