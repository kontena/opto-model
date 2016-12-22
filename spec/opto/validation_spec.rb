require 'spec_helper'

describe Opto::Model do
  context "validation" do

    before(:each) do
      Object.send(:remove_const, :ValidTestModel) if Object.constants.include?(:ValidTestModel)
      Object.send(:remove_const, :ValidAssocTestModel) if Object.constants.include?(:ValidAssocTestModel)
    end

    let(:valid_test_model) {
      class ValidTestModel
        include Opto::Model

        attribute :foo, :string, min_length: 3
      end
      ValidTestModel
    }

    let(:valid_assoc_test_model) {
      class ValidAssocTestModel
        include Opto::Model

        attribute :foo, :string, min_length: 3
        has_one :friend, ValidAssocTestModel, required: true
        has_many :friends, ValidAssocTestModel, required: true
      end
      ValidAssocTestModel
    }

    it 'knows when valid' do
      instance = valid_test_model.new(foo: 'a')
      expect(instance.valid?).to be_falsey
      instance.foo = 'abc'
      expect(instance.valid?).to be_truthy
    end

    it 'knows why not valid' do
      instance = valid_test_model.new(foo: 'a')
      expect(instance.errors[:foo][:validate_min_length]).to start_with("Too short")
    end

    it 'knows why a child is invalid' do
      instance = valid_assoc_test_model.new(foo: 'abc', friend: { foo: 'a' }, friends: [ { foo: 'abc'}, { foo: 'a'}])
      expect(instance.errors[:friend][:foo][:validate_min_length]).to start_with("Too short")
      expect(instance.errors[:friends][1][:foo][:validate_min_length]).to start_with("Too short")
    end

    it 'can validate without checking children' do
      #instance = valid_assoc_test_model.new(foo: 'abc')
      instance = valid_assoc_test_model.new(foo: 'abc', friend: { foo: 'a' }, friends: [ { foo: 'abc'}, { foo: 'a'}])
      expect(instance.valid?).to be_falsey
      expect(instance.valid?(false)).to be_truthy
    end

    it 'can get errors without digging from children' do
      instance = valid_assoc_test_model.new(foo: 'abc')
      expect(instance.errors[:friend][:presence]).to start_with("Missing")
      expect(instance.errors(false)[:friend]).to be_nil
      expect(instance.errors[:friends][:presence]).to start_with("Collection")
      expect(instance.errors(false)[:friends]).to be_nil
    end
  end
end

