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
    @id = self.id
    DB.exec("UPDATE cities Set name = '#{@name}' WHERE id = #{@id};")
  end
end
