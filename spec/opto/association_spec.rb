require 'spec_helper'

describe Opto::Model do

  before(:each) do
    Object.send(:remove_const, :AssocTestModel) if Object.constants.include?(:AssocTestModel)
  end

  context "instances" do
    context "association" do
      let(:assoc_test_model) {
        class AssocTestModel
          include Opto::Model

          attribute :foo, :string
          attribute :name, :string, required: false

          has_one :friend, AssocTestModel, required: true
          has_many :friends, AssocTestModel, required: true
        end
        AssocTestModel
      }

      it 'raises for duplicate has_one' do
        expect{
          class FooFoo
            include Opto::Model

            has_one :foo, FooFoo
            has_one :foo, FooFoo
          end
        }.to raise_error(RuntimeError)
      end

      it 'raises for duplicate has_many' do
        expect{
          class FooFoo
            include Opto::Model

            has_many :foo, FooFoo
            has_many :foo, FooFoo
          end
        }.to raise_error(RuntimeError)
      end

      it 'can has_one' do
        instance = assoc_test_model.new
        expect(instance).to respond_to(:friend)
        expect(instance).to respond_to(:friends)
      end

      it 'can initialize has_one children' do
        instance = assoc_test_model.new(friend: { foo: 'bar' })
        expect(instance.friend).to be_kind_of(assoc_test_model)
        expect(instance.friend.foo).to eq 'bar'
        expect(instance.friend.name).to be_nil
      end

      it 'can initialize named has_one children' do
        instance = assoc_test_model.new(friend: { baz: { foo: 'bar' }})
        expect(instance.friend).to be_kind_of(assoc_test_model)
        expect(instance.friend.foo).to eq 'bar'
        expect(instance.friend.name).to eq 'baz'
      end

      it 'can initialize has_many children' do
        instance = assoc_test_model.new(friends: [ {foo: 'bar' }, {foo: 'baz'} ])
        expect(instance.friends.first).to be_kind_of(assoc_test_model)
        expect(instance.friends.size).to eq 2
        expect(instance.friends.first.foo).to eq 'bar'
        expect(instance.friends.last.foo).to eq 'baz'
      end

      it 'can initialize named has_many children' do
        instance = assoc_test_model.new(friends: { baz: {foo: 'bar' }, buz: {foo: 'baz'} })
        expect(instance.friends.first).to be_kind_of(assoc_test_model)
        expect(instance.friends.size).to eq 2
        expect(instance.friends.first.foo).to eq 'bar'
        expect(instance.friends.last.foo).to eq 'baz'
        expect(instance.friends.first.name).to eq 'baz'
        expect(instance.friends.last.name).to eq 'buz'
      end

      it 'can clear an association' do
        instance = assoc_test_model.new(friend: { foo: 'bar' })
        instance.friend = nil
        expect(instance.friend).to be_nil
      end

      it 'creates no association when nil is passed' do
        instance = assoc_test_model.new(friend: nil)
        expect(instance.friend).to be_nil
        instance = assoc_test_model.new(friends: nil)
        expect(instance.friends).to be_empty
      end

      it 'raises if trying to pass something strange to an association' do
        expect{assoc_test_model.new(friend: 1)}.to raise_error(TypeError)
        expect{assoc_test_model.new(friends: 1)}.to raise_error(TypeError)
        expect{assoc_test_model.new(friends: [1])}.to raise_error(TypeError)
      end

      it 'can replace the members array' do
        instance = assoc_test_model.new(friends: [ {foo: 'bar' }, {foo: 'baz'} ])
        friends = [assoc_test_model.new(foo: 'bra')]
        instance.friends = friends
        expect(instance.friends.size).to eq 1
        expect(instance.friends.first.foo).to eq 'bra'
      end

      it 'converts children to hash too' do
        instance = assoc_test_model.new(foo: 'root', friend: { foo: 'foo'}, friends: [ {foo: 'bar' }, {foo: 'baz'} ])
        hash = instance.to_h
        expect(hash["foo"]).to eq 'root'
        expect(hash[:friends]).to be_kind_of(Array)
        expect(hash[:friends].size).to eq 2
        expect(hash[:friend]).to be_kind_of(Hash)
        expect(hash[:friend]["foo"]).to eq 'foo'
        expect(hash[:friends].first["foo"]).to eq 'bar'
        expect(hash[:friends].last["foo"]).to eq 'baz'
      end

      it 'skips converting children to hash when asked' do
        instance = assoc_test_model.new(foo: 'root', friend: { foo: 'foo'}, friends: [ {foo: 'bar' }, {foo: 'baz'} ])
        hash = instance.to_h(false)
        expect(hash["foo"]).to eq 'root'
        expect(hash[:friends]).to be_nil
        expect(hash[:friend]).to be_nil
        expect(hash["friends"]).to be_nil
        expect(hash["friend"]).to be_nil
      end

    end
  end
end
