require 'hash_attribute_assignment/hash_validation_error'
require 'hash_attribute_assignment/hash_attribute_assignor'
require 'hash_attribute_assignment/hash_validation'
require 'hash_attribute_assignment/class_methods'

module HashAttributeAssignment
  def self.included(base)
    base.extend ClassMethods
  end

  def initialize(hash = {})
    HashAttributeAssignor.new(self, hash).assign
  end
end
