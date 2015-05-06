require "spec_helper"

describe(City) do

  describe('#save') do
    it("adds a city to the city table") do
      test_city = City.new({:id => nil, :name => "Portland"})
      test_city.save
      expect(City.all).to(eq([test_city]))
    end
  end

  describe('.find') do
    it('returns a city with the given id') do
      test_city = City.new({:id => nil, :name => "Orlando"})
      test_city.save
      expect(City.find(test_city.id)).to eq(test_city)
    end
  end

  describe('#update') do
    it("lets you update cities in the database") do
      test_city = City.new({:id => nil, :name => "Boston"})
      test_city.save
      test_city.update({:name => "Framingham"})
      expect(test_city.name()).to eq("Framingham")
    end
  end

  describe('#delete') do
    it('lets you delete a city from the database') do
      test_city = City.new({:id => nil, :name => "Gotham"})
      test_city.save
      test_city2 = City.new({:id => nil, :name => "Metropolis"})
      test_city2.save
      test_city.delete()
      expect(City.all).to eq([test_city2])
    end
  end

end
