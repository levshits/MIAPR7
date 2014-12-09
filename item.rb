require_relative 'rule'
class Item
  attr_accessor :rule,
                :marker_index
  def initialize(rule, marker_index)
    @rule = rule
    @marker_index = marker_index
  end
  def markered
    if(@marker_index>=@rule.right.size)
      return '$'
    else
      return rule.right[@marker_index]
    end
  end
  def last
    return rule.right.last
  end
  def == other
    return self.rule == other.rule && self.marker_index == other.marker_index
  end
end