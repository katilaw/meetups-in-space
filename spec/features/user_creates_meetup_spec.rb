require 'spec_helper'

feature "user creates meetup" do

  let!(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario "User must sign in to create meetup" do
    visit "/meetups"
    click_link("Link to New Event Page")

    expect(page).to have_content("Please sign in")
  end

  scenario "user signs in" do
    user
    visit "/meetups"
    sign_in_as user

    expect(page).to have_content "You're now signed in as #{user.username}!"
    expect(page).to have_content "Link to New Event Page"
  end

  scenario "user fills out create meetup form" do

    v = "Meetups in Space Signed in as jarlax1 Sign Out Please fill in the Event Name, Description and Location. Create a New Event Event Name Description Location Creator's Name"

    visit "/meetups"
    sign_in_as user

    visit "/meetups"
    click_link("Link to New Event Page")

    visit "/new"
    fill_in('Event Name', with: 'Cars')
    click_button("Add")

    expect(page).to have_content(v)
  end

  scenario "user sucessfully completes form and views new meetup" do

    v = "You successfully created a Meetup."

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

    expect(page).to have_content(v)
  end
end
