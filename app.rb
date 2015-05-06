require './lib/train'
require './lib/city'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'
also_reload 'lib/**/*.rb'

DB = PG.connect({:dbname => 'trains'})

get('/') do
  erb(:index)
end

get('/trains') do
  @trains = Train.all
  erb(:trains)
end

post('/trains') do
  @name = params.fetch('name')
  Train.new({:id => nil, :name => @name}).save
  @trains = Train.all
  erb(:trains)
end

get('/trains/new') do
  erb(:train_form)
end

get('/train_cities/:id') do
  train_id = params.fetch('id').to_i
  @train = Train.find(train_id)
  @cities = @train.cities
  @all_cities = City.all
  erb(:train_cities)
end

patch('/train_cities/:id') do
  train_id = params.fetch("id").to_i
  @train = Train.find(train_id)
  city_ids = params.fetch("cities")
  @train.update({:city_ids => [city_ids]})
  @cities = @train.cities
  @all_cities = City.all()
  erb(:train_cities)
end

get('/cities') do
  @cities = City.all
  erb(:cities)
end

post('/cities') do
  @name = params.fetch('name')
  City.new({:id => nil, :name => @name}).save
  @cities = City.all
  erb(:cities)
end

get('/cities/new') do
  erb(:city_form)
end
