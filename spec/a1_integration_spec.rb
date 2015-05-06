require('capybara/rspec')
require('./app')
require "spec_helper"

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('viewing and adding trains', {:type => :feature}) do

  it('processes user input to add a city to a train', {:type => :feature}) do
    visit('/trains/new')
    fill_in('name', :with => "Blue Line")
    click_on('Save')
    expect(page).to have_content("Blue Line")
    visit('/cities/new')
    fill_in("name", :with => "Portland")
    click_on('Save')
    expect(page).to have_content("Portland")
    visit('/trains')
    click_on("Blue Line")
    click_on("Add")
    select "Portland", from: "cities"
    click_on("Add")
    expect(page).to have_content("Portland")

  end
end
