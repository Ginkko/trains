class City
  attr_reader :id, :name

  def initialize(attributes)
      @id = attributes.fetch(:id)
      @name = attributes.fetch(:name)
  end

  def self.all
    cities = []
    results = DB.exec("SELECT * FROM cities;")
    results.each do |city|
      id = city.fetch('id').to_i
      name = city.fetch('name')
      cities.push(City.new({:id => id, :name => name}))
    end
    cities
  end

  def save
    results = DB.exec("INSERT INTO cities (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first.fetch('id').to_i
  end

  def ==(other_city)
    same_name = @name == other_city.name
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM cities WHERE id = #{id};")
    name = result.first.fetch('name')
    City.new({:id => id.to_i, :name => name})
  end

  def generate_time
    rand_int = rand(1..24)
    "#{rand_int}:00"
  end

  def update(attributes)
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE cities SET name = '#{@name}' WHERE id = #{self.id};")
    attributes.fetch(:train_ids, []).each do |train_id|
      time = self.generate_time
      DB.exec("INSERT INTO stops (city_id, train_id, time) VALUES (#{self.id}, #{train_id}, '#{time}');")
    end
  end

  def delete
    DB.exec("DELETE FROM cities WHERE id = #{self.id()};")
    DB.exec("DELETE FROM stops WHERE city_id = #{self.id};")
  end

  def delete_stop(train)
    DB.exec("DELETE FROM stops WHERE city_id = #{self.id} and train_id = #{train.id};")
  end

  def trains
    city_trains = []
    results = DB.exec("SELECT train_id, time FROM stops WHERE city_id = #{self.id};")
    results.each do |result|
      train_id = result.fetch('train_id').to_i
      train = DB.exec("SELECT * FROM trains WHERE id = #{train_id};")
      time = result.fetch('time').to_s
      name = train.first.fetch('name')
      city_trains.push([Train.new({:id => train_id, :name => name}), time])
    end
    city_trains
  end

end
