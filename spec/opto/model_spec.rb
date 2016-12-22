require 'spec_helper'

describe Opto::Model do
  it 'has a version number' do
    expect(Opto::Model::VERSION).not_to be nil
  end

  before(:each) do
    Object.send(:remove_const, :TestModel) if Object.constants.include?(:TestModel)
    Object.send(:remove_const, :FooFoo) if Object.constants.include?(:FooFoo)
  end

  it 'raises when duplicate attributes are added' do
    expect{
      class FooFoo
        include Opto::Model

        attribute :foo, :string
        attribute :foo, :string
      end
    }.to raise_error(RuntimeError)
  end


  context "instances" do

    let(:test_model) {
      class TestModel
        include Opto::Model

        attribute :foo, :string
      end
      TestModel
    }

    it 'creates an instance without params' do
      instance = test_model.new
      expect(instance.foo).to be_nil
    end

    it 'creates an instance with params' do
      instance = test_model.new(foo: 'bar')
      expect(instance.foo).to eq 'bar'
    end

    it 'raises when creating an instance with invalid params' do
      expect{test_model.new(bar: 'foo')}.to raise_error(ArgumentError) do |ex|
        expect(ex.message).to start_with('Unknown attribute')
      end
    end

    it 'provides access to the opto option' do
      instance = test_model.new
      expect(instance).to respond_to(:foo_handler)
      expect(instance.foo_handler.type).to eq 'string'
    end

    it 'cleans up the collection inspect response' do
      instance = test_model.new
      expect(instance.collection.inspect).to match(/members: \[:foo\]/)
    end

    it 'can convert to hash' do
      instance = test_model.new(foo: 'bar')
      expect(instance.to_h["foo"]).to eq 'bar'
    end

    it 'creates a hash that can create a twin' do
      instance = test_model.new(test_model.new(foo: 'bar').to_h)
      expect(instance.foo).to eq 'bar'
    end

    it 'can be inspected' do
      instance = test_model.new(foo: 'bar')
      expect(instance.inspect).to match(/string:foo/)
    end

    it 'also works through Opto.model' do

      class FooFoo
        include Opto.model

        attribute :foo, :string
      end
      expect(FooFoo.new(foo: 'bar').foo).to eq 'bar'
    end
  end

end
