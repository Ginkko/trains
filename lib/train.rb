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

end
