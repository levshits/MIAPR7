class RuleCondition
  attr_accessor :rule,
                :right_part_index,
                :next_terminal
  def initialize(rule, right_part_index, next_terminal)
    @rule = rule
    @right_part_index = right_part_index
    @next_terminal = next_terminal
  end
end