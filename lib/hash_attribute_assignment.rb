module HashAttributeAssignment
  module ClassMethods
    HashValidation = Struct.new(:proc, :message)

    def validate_hash(proc, options = { message: 'Hash failed validation' })
      raise ArgumentError('First arg must be a call-able') unless proc.respond_to? :call
      class_variable_set(:@@hash_validations, hash_validations + [HashValidation.new(proc, options[:message])])
    end

    private

    def hash_validations
      class_variable_defined?(:@@hash_validations) ? class_variable_get(:@@hash_validations) : []
    end
  end
  class HashValidationError < StandardError; end
  class HashAttributeAssignor
    def initialize(instance, hash = {})
      @hash = hash
      @klass = instance.class
      @instance = instance
      @hash_validations = klass.class_variable_get(:@@hash_validations)
    end

    def assign
      check_required_keys if klass.const_defined?(:REQUIRED_KEYS)
      merge_default_hash! if klass.const_defined?(:DEFAULT_HASH)
      validate_hash!
      assign_asstributes
    end

    private

    attr_reader :klass, :instance, :hash_validations
    attr_accessor :hash

    def assign_asstributes
      hash.each do |key, value|
        instance.instance_variable_set("@#{key}".to_sym, value)
      end
    end

    def check_required_keys
      required_keys.each do |key|
        raise ArgumentError, "Required key '#{key}' missing for #{klass}" unless hash.key? key
      end
    end

    def merge_default_hash!
      self.hash = default_hash.merge(hash)
    end

    def validate_hash!
      hash_validations.each do |validation|
        raise HashValidationError, validation.message unless validation.proc.call hash
      end
    end

    def required_keys
      klass.const_get(:REQUIRED_KEYS)
    end

    def default_hash
      klass.const_get(:DEFAULT_HASH)
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  def initialize(hash = {})
    HashAttributeAssignor.new(self, hash).assign
  end
end
