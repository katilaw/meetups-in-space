require 'spec_helper'
require 'pry'

feature "user views member in created group" do

  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let!(:meetup) do
    Meetup.create(
      event_name: "Car Talk",
      time: "7:00PM",
      location: "33 Harrison Ave",
      description: "Talk about tech"
    )
  end

  let!(:membership) do
    Membership.create(
      user_id: "#{user.id}",
      meetup_id: "#{Meetup.first.id}",
      created_at: "#{Time.now}",
      updated_at: "#{Time.now}",
      creator: "#{true}"
    )
  end

  let!(:user1) do
    User.create(
      provider: "github",
      uid: "2",
      username: "jarlax2",
      email: "jarlax2@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/56789?v=3&s=400"
    )
  end

  def joins_membership
    Membership.create(
      user_id: "#{user1.id}",
      meetup_id: "#{Meetup.first.id}",
      created_at: "#{Time.now}",
      updated_at: "#{Time.now}",
      creator: "#{false}"
    )
  end

  scenario "user successfully joins a meetup" do
    visit "/meetups"
    sign_in_as user

    visit "/meetups"
    click_link("Car Talk")
    visit "/meetups/#{Meetup.first.id}"
    click_button("Join Meetup")
    joins_membership

    visit "/meetups/#{Meetup.first.id}"

    expect(page).to have_content("#{user1.username}")
    expect(page).to have_css("img[src*='#{user1.avatar_url}']")
    page.has_content?("You have successfully joined the Meetup!")
  end

  scenario "user not signed in, can't join a meetup" do
    visit "/meetups"
    click_link("Car Talk")
    visit "/meetups/#{Meetup.first.id}"
    click_button("Join Meetup")
    visit "/meetups/#{Meetup.first.id}"


    expect(page).to_not have_content("#{user1.username}")
    expect(page).to_not have_css("img[src*='#{user1.avatar_url}']")
    page.has_content?("Please sign in.")
  end
end
