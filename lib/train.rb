class Train
  attr_reader :id, :name

  def initialize(attributes)
      @id = attributes.fetch(:id)
      @name = attributes.fetch(:name)
  end

  def self.all
    trains = []
    results = DB.exec("SELECT * FROM trains;")
    results.each do |train|
      id = train.fetch('id').to_i
      name = train.fetch('name')
      trains.push(Train.new({:id => id, :name => name}))
    end
    trains
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM trains WHERE id = #{id};")
    name = result.first.fetch('name')
    Train.new({:id => id.to_i, :name => name})
  end

  def save
    results = DB.exec("INSERT INTO trains (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first.fetch('id').to_i
  end

  def ==(other_train)
    same_name = @name == other_train.name
  end

  def generate_time
    rand_int = rand(1..24)
    "#{rand_int}:00"
  end

  def update(attributes)
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE trains SET name = '#{@name}' WHERE id = #{self.id};")
    attributes.fetch(:city_ids, []).each do |city_id|
      time = self.generate_time
      DB.exec("INSERT INTO stops (city_id, train_id, time) VALUES (#{city_id}, #{self.id}, '#{time}');")
    end
  end

  def delete
    DB.exec("DELETE FROM trains WHERE id = #{self.id()};")
    DB.exec("DELETE FROM stops WHERE train_id = #{self.id};")
  end

  def delete_stop(city)
    DB.exec("DELETE FROM stops WHERE train_id = #{self.id} and city_id = #{city.id};")
  end

  def cities
    train_cities = []
    results = DB.exec("SELECT city_id, time FROM stops WHERE train_id = #{self.id};")
    results.each do |result|
      city_id = result.fetch("city_id").to_i
      city = DB.exec("SELECT * FROM cities WHERE id = #{city_id};")
      time = result.fetch('time').to_s
      name = city.first.fetch("name")
      train_cities.push([City.new({:id => city_id, :name => name}), time])
    end
    train_cities
  end

  def cost
    cost = rand(1..10)
    "$#{cost}.00"
  end
end
