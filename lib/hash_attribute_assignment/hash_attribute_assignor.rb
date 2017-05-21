module HashAttributeAssignment
  class HashAttributeAssignor
    def initialize(instance, hash = {})
      @hash = hash
      @klass = instance.class
      @instance = instance
      @hash_validations = klass.hash_validations
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
end
