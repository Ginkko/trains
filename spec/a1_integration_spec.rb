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
  it('randomly generates a time for a stop', {:type => :feature}) do
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
    expect(page).to have_content(":00")
  end
end

describe('updating and deleting cities', {:type => :feature}) do
  it('processes user name changes and changes the name accordingly') do
    visit('/cities/new')
    fill_in('name', :with => "Metropolis")
    click_on('Save')
    click_on("Metropolis")
    fill_in("new_name", :with => "NYC")
    click_on("Update")
    expect(page).to have_content("NYC")
  end
  it('deletes a city from the database') do
    visit('/cities/new')
    fill_in('name', :with => "Metropolis")
    click_on('Save')
    expect(page).to have_content("Metropolis")
    click_on('Metropolis')
    click_button('delete_city')
    expect(page).to have_content("deleted")
  end
end
