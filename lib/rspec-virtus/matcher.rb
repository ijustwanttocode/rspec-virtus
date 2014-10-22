module RSpec
  module Virtus
    class Matcher
      def initialize(attribute_name)
        @attribute_name = attribute_name
        @options = {}
      end

      def description
        "have #{@attribute_name} defined"
      end

      def of_type(type, options={})
        @options[:type] = type
        @options[:member_type] = options.delete(:member_type)
        self
      end

      def with_default(default_value)
        @options[:default_value] = default_value
        self
      end

      def matches?(subject)
        @subject = subject

        @match_attribute_exists = attribute_exists?
        @match_type_correct = type_correct?
        @match_default_value_correct = default_value_correct?

        @match_attribute_exists && @match_type_correct && @match_default_value_correct
      end

      def failure_message
        msg = ["expected #{@attribute_name} to be defined"]
        msg << "have correct type" if @options.has_key?(:type) && !@match_type_correct
        msg << "have correct default value" if @options.has_key?(:default_value) && !@match_default_value_correct
        msg.join(' and ')
      end

      def failure_message_when_negated
        msg = ["expected #{@attribute_name} not to be defined"]
        msg << "not have correct type" if @options.has_key?(:type)
        msg << "not have correct default value" if @options.has_key?(:default_value)
        msg.join(' and ')
      end

      private

      def attribute
        @subject.attribute_set[@attribute_name]
      end

      def member_type
        attribute.member_type.primitive
      end

      def attribute_type
        attribute.primitive
      end

      def attribute_exists?
        attribute != nil
      end

      def attribute_default_value
        attribute.default_value.value
      end

      def type_correct?
        if @options[:member_type]
          member_type == @options[:member_type] && attribute_type == @options[:type]
        elsif @options[:type]
          attribute_type == @options[:type]
        else
          true
        end
      end

      def default_value_correct?
        if @options[:default_value]
          attribute_default_value == @options[:default_value]
        else
          true
        end
      end
    end
  end
end
