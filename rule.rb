require_relative 'syntax_tree_node'
class Rule
  attr_accessor :left,
                :right
  def initialize(left_part, right_part)
    @left = left_part
    @right = right_part
  end
  def has?(x)
    return @right.include?(x)
  end
  def next(x)
    @right.each_index { |index|
    if @right[index] == x
      if index<@right.size
        return @right[index+1]
      else
        return nil
      end
    end}
  end
end