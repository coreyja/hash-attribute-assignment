require 'spec_helper'

RSpec.describe HashAttributeAssignment do
  let(:klass) do
    Class.new do
      include HashAttributeAssignment

      DEFAULT_HASH = {}.freeze
      REQUIRED_KEYS = [].freeze

      attr_reader :foo, :other_attribute
    end
  end

  let(:attributes) do
    {
      foo: :bar,
      other_attribute: 5.7,
      attribute_without_reader: :haha
    }
  end

  subject { klass.new attributes }

  it 'sets arbitrary attributes correctly which work with attr_readers' do
    attributes.keys.each do |key|
      expect(subject.instance_variable_get("@#{key}")).to eq attributes[key]
    end
    expect(subject.foo).to eq :bar
    expect(subject.other_attribute).to eq 5.7
  end

  context 'when the klass has required keys' do
    let(:klass) do
      Class.new do
        include HashAttributeAssignment

        DEFAULT_HASH = {}.freeze
        REQUIRED_KEYS = %i(foo).freeze
      end
    end

    context 'when the required key is provided' do
      context 'when the required key is explicitly nil' do
        let(:attributes) { { foo: nil } }

        it 'initializes' do
          expect { subject }.to_not raise_error
        end
      end

      let(:attributes) { { foo: :bar } }

      it 'initializes' do
        expect { subject }.to_not raise_error
      end
    end

    context 'when the required key is NOT provided' do
      let(:attributes) { {} }

      it 'does not initialize' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end

  context 'when a default hash is provided' do
    let(:klass) do
      Class.new do
        include HashAttributeAssignment

        DEFAULT_HASH = {
          foo: :bar,
          other_attribute: 5.7
        }.freeze
        REQUIRED_KEYS = [].freeze

        attr_reader :foo, :other_attribute
      end
    end

    context 'when inited with an empty hash' do
      let(:attributes) { {} }

      it 'uses the defaults' do
        expect(subject.foo).to eq :bar
        expect(subject.other_attribute).to eq 5.7
      end
    end

    context 'when a different value is provided for some attributes' do
      let(:attributes) do
        {
          foo: 1
        }
      end

      it 'uses the provided values' do
        expect(subject.foo).to eq 1
        expect(subject.other_attribute).to eq 5.7
      end
    end
  end

  context 'when there is a validation proc given' do
    let(:klass) do
      Class.new do
        include HashAttributeAssignment
        DEFAULT_HASH = {}.freeze
        REQUIRED_KEYS = [].freeze

        validate_hash ->(hash) { hash[:foo] == :bar }
      end
    end

    context 'when the attributes pass validation' do
      let(:attributes) { { foo: :bar } }

      it 'initializes' do
        expect { subject }.to_not raise_error
      end
    end

    context 'when the attributes do NOT pass validation' do
      let(:attributes) { { foo: 1 } }

      it 'does not initialize' do
        expect { subject }.to raise_error HashAttributeAssignment::HashValidationError, 'Hash failed validation'
      end
    end
  end
end
