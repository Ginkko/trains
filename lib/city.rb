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

end
