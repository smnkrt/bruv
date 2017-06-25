require "bruv/version"

# Module adding Bruv.attribute and Bruv.attributes helper methods.
# It adds an initializer method which sets values for defined attributes
# and perform additional conversions if specified.
#
# @example
#   class MyClass
#     include Bruv
#     attribute :price, ->(ci) { Float(ci) }
#     attributes :age, :type
#   end
#
#   mc = MyClass.new("123", 100, :user)
#   mc.first_name # => 123.00
#   mc.age        # => 100
#   mc.type       # => :user
#
module Bruv
  class BruvArgumentError < ArgumentError; end

  def self.included(obj)
    obj.class_eval do
      # Array of registered attribute names.
      @instance_variables = []

      # Hash of procs for registered attributes.
      @procs = {}

      # Getter for @instance_variables
      # @return [Array]
      def self.instance_variables
        @instance_variables
      end

      # Getter for @procs
      # @return [Hash]
      def self.procs
        @procs
      end

      # Appends single variable name to {instance_variables} and if mproc
      # is passed it adds it to {procs}.
      # @param name [#to_sym] Name of the variable to be defined.
      # @param mproc [#call] Proc called in the #initialize method
      #   which can perform additional value conversions
      # @return [Hash]
      # @example
      #   attribute :tag, ->(t) { t.downcase }
      #   attribute :code, ->(c) { { a: 123, b: 321 }.fetch(c) }
      def self.attribute(name, mproc = nil)
        mname = name.to_sym
        instance_variables << mname
        procs[mname] = mproc
      end

      # Appends multiple variable names to {instance_variables}
      # @param *names [Array<#to_sym>] Array of names, each name variable should
      #   respond to #to_sym
      # @return [Array]
      # @example
      #   attributes :first_name, :last_name
      def self.attributes(*names)
        @instance_variables += names.map(&:to_sym)
      end

      # Defines getter methods for each attribute in {instance_variables},
      # and calls a proc for an attribute if it was registered.
      # @note Attributes are defined in order in which they were registered.
      # @param *args [Array] Array of attribute values.
      # @raise [BruvArgumentError] when more values are passed that registered attributes.
      def initialize(*args)
        raise_argument_error if args.size > self.class.instance_variables.size
        self.class.instance_variables.each_with_index do |var, index|
          mproc = self.class.procs[var.to_sym] || proc { |a| a }
          instance_variable_set("@#{var}", mproc.call(args[index]))
          define_singleton_method(var) { instance_variable_get("@#{var}") }
        end
      end

      private

      # Prepares Error message
      def raise_argument_error
        message = "Number of arguments exceeds number of instance variables for:"
        raise BruvArgumentError, "#{message} #{self.class.name}"
      end
    end
  end
end
