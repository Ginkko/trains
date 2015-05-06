require "spec_helper"

describe(Train) do

  describe('#save') do
    it("adds a train to the trains table") do
      test_train = Train.new({:id => nil, :name => "Blue Line"})
      test_train.save
      expect(Train.all).to(eq([test_train]))
    end
  end

  describe('.find') do
    it('returns a train with the given id') do
      test_train = Train.new({:id => nil, :name => "Blue Line"})
      test_train.save
      expect(Train.find(test_train.id)).to eq(test_train)
    end
  end
  describe('#update') do
    it("lets you update trains in the database") do
      test_train = Train.new({:id => nil, :name => "Red Line"})
      test_train.save
      test_train.update({:name => "Green Line"})
      expect(test_train.name()).to eq("Green Line")
    end
  end

end
