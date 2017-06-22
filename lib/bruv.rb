require "bruv/version"

module Bruv
  class BruvArgumentError < ArgumentError; end

  def self.included(obj)
    obj.class_eval do
      @instance_variables = []
      @procs = {}

      def self.instance_variables
        @instance_variables
      end

      def self.procs
        @procs
      end

      def self.attribute(name, mproc = nil)
        mname = name.to_sym
        instance_variables << mname
        procs[mname] = mproc
      end

      def self.attributes(*names)
        @instance_variables += names.map(&:to_sym)
      end

      def initialize(*args)
        raise_argument_error if args.size > self.class.instance_variables.size
        self.class.instance_variables.each_with_index do |var, index|
          mproc = self.class.procs[var.to_sym] || proc { |a| a }
          instance_variable_set("@#{var}", mproc.call(args[index]))
          define_singleton_method(var) { instance_variable_get("@#{var}") }
        end
      end

      private

      def raise_argument_error
        message = "Number of arguments exceeds number of instance variables for: #{self.class.name}"
        raise BruvArgumentError, message
      end
    end
  end
end
