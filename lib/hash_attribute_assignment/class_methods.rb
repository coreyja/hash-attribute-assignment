module HashAttributeAssignment
  module ClassMethods
    HashValidation = Struct.new(:proc, :message)

    def validate_hash(proc, options = { message: 'Hash failed validation' })
      raise ArgumentError('First arg must be a call-able') unless proc.respond_to? :call
      class_variable_set(:@@hash_validations, hash_validations + [HashValidation.new(proc, options[:message])])
    end

    def hash_validations
      class_variable_defined?(:@@hash_validations) ? class_variable_get(:@@hash_validations) : []
    end
  end
end
