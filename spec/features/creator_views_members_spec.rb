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

  let!(:user1) do
    User.create(
      provider: "github",
      uid: "2",
      username: "jarlax2",
      email: "jarlax2@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  def create_memberships
    Membership.create(
      user_id: "#{user.id}",
      meetup_id: "#{Meetup.first.id}",
      created_at: "#{Time.now}",
      updated_at: "#{Time.now}",
      creator: "#{true}"
    )
    Membership.create(
      user_id: "#{user1.id}",
      meetup_id: "#{Meetup.first.id}",
      created_at: "#{Time.now}",
      updated_at: "#{Time.now}",
      creator: "#{false}"
    )
  end

  scenario "creator views members" do
    visit "/meetups"
    sign_in_as user

    visit "/meetups"
    click_link("Link to New Event Page")

    visit "/new"
    fill_in('Event Name', with: 'Cars')
    fill_in('Description', with: 'Talk about cars a lot')
    fill_in('Location', with: 'Boston')
    fill_in("Creator's Name", with: 'Me, Myself and I')
    click_button("Add")

    create_memberships

    visit "/meetups/#{Meetup.first.id}"
    expect(page).to have_content("#{user.username}")
    expect(page).to have_css("img[src*='#{user.avatar_url}']")
    expect(page).to have_content("#{user1.username}")
    expect(page).to have_css("img[src*='#{user1.avatar_url}']")
  end
end
