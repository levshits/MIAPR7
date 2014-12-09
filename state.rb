require_relative 'item'
class State
  attr_reader :number,
              :type,
              :rule,
              :items
  def initialize( type, number, rule = '')
    @type = type
    @number = number
    @rule = rule
  end
end