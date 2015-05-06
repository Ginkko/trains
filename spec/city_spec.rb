require "spec_helper"

describe(City) do

  describe('#save') do
    it("adds a city to the city table") do
      test_city = City.new({:id => nil, :name => "Portland"})
      test_city.save
      expect(City.all).to(eq([test_city]))
    end
  end
end
