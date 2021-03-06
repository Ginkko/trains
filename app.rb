require './lib/train'
require './lib/city'
require './lib/user'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'
also_reload 'lib/**/*.rb'

DB = PG.connect({:dbname => 'trains'})

get('/') do
  @@user = User.new
  erb(:index)
end

post('/home') do
  if params.fetch('user') == "admin"
    @@user.admin_flag
  else @@user.user_flag
  end
  erb(:home)
end

get('/ticket') do
  @all_cities = City.all
  erb(:ticket)
end

post('/process') do
  city = City.find(params.fetch('cities'))
  redirect("/ticket/#{city.id}")
end

get('/ticket/:id') do
  @city = City.find(params.fetch('id'))
  @trains = @city.trains
  erb(:ticket_line)
end

get('/ticket_success') do
  @city = City.find(params.fetch('hidden_id_city'))
  @train = Train.find(params.fetch('train'))
  @result = DB.exec("SELECT time FROM stops WHERE city_id = #{@city.id} AND train_id = #{@train.id};")
  @time = ""
  @result.each do |result|
    @time = result.fetch('time').to_s
  end
  erb(:ticket_success)
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

get('/trains/:id') do
  train_id = params.fetch('id').to_i
  @train = Train.find(train_id)
  @cities = @train.cities
  @all_cities = City.all
  erb(:train_cities)
end

patch('/trains/:id') do
  train_id = params.fetch("id").to_i
  @train = Train.find(train_id)
  city_ids = params.fetch("cities")
  @train.update({:city_ids => [city_ids]})
  @cities = @train.cities
  @all_cities = City.all()
  erb(:train_cities)
end

patch('/trains/:id/updated') do
  train_id = params.fetch("id").to_i
  @train = Train.find(train_id)
  @cities = @train.cities
  @all_cities = City.all
  if params.fetch("new_name") != nil
    @train.update(:name => params.fetch("new_name"))
  end
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

get('/cities/:id') do
  city_id = params.fetch('id').to_i
  @city = City.find(city_id)
  @trains = @city.trains
  @all_trains = Train.all
  erb(:city_trains)
end

patch('/cities/:id') do
  city_id = params.fetch("id").to_i
  @city = City.find(city_id)
  train_ids = params.fetch("trains")
  @city.update({:train_ids => [train_ids]})
  @trains = @city.trains
  @all_trains = Train.all()
  erb(:city_trains)
end

patch('/cities/:id/updated') do
  city_id = params.fetch("id").to_i
  @city = City.find(city_id)
  @trains = @city.trains
  @all_trains = Train.all()
  if params.fetch("new_name") != nil
    @city.update(:name => params.fetch("new_name"))
  end
  erb(:city_trains)
end

delete('/deleted') do
  if params.fetch("train_to_delete") != "" && params.fetch("hidden_id_city") != ""
    train_id = params.fetch("train_to_delete").to_i
    city_id = params.fetch("hidden_id_city").to_i
    city = City.find(city_id)
    train2 = Train.find(train_id)
    train2.delete_stop(city)
    erb(:deleted)
  elsif params.fetch("city_to_delete") != "" && params.fetch("hidden_id_train") != ""
    city_id = params.fetch("city_to_delete").to_i
    train_id = params.fetch("hidden_id_train").to_i
    train = Train.find(train_id)
    city2 = City.find(city_id)
    city2.delete_stop(train)
    erb(:deleted)
  elsif
    params.fetch("hidden_id_train") != ""
    train_id = params.fetch("hidden_id_train").to_i
    train = Train.find(train_id)
    train.delete
    erb(:deleted)
  elsif params.fetch("hidden_id_city") != ""
    city_id = params.fetch("hidden_id_city").to_i
    city = City.find(city_id)
    city.delete
    erb(:deleted)
  else
  end
end
