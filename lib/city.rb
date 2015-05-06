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

  def update(attributes)
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE cities SET name = '#{@name}' WHERE id = #{self.id};")

    attributes.fetch(:train_ids, []).each do |train_id|
      DB.exec("INSERT INTO stops (city_id, train_id) VALUES (#{self.id}, #{train_id});")
    end
  end

  def delete
    DB.exec("DELETE FROM cities WHERE id = #{self.id()};")
  end

  def trains
    city_trains = []
    results = DB.exec("SELECT train_id FROM stops WHERE city_id = #{self.id};")
    results.each do |result|
      train_id = result.fetch('train_id').to_i
      train = DB.exec("SELECT * FROM trains WHERE id = #{train_id};")
      name = train.first.fetch('name')
      city_trains.push(Train.new({:id => train_id, :name => name}))
    end
    city_trains
  end
end
