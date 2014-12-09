require_relative 'condition'
require_relative 'rule'
require_relative 'item'
require_relative 'parser_action'
require_relative 'state'
require 'yaml'

class Grammar
  attr_reader :FSM
  def initialize(rules)
    @symbols = []
    @rules = rules
    @FSM = {}
    @conditions = []
    @symbols = []
    generate_items_sets
  end
  def get_all_terminals_for_state(index)
    result=@FSM[index].keys.select{|token| token[0]=~/[^A-Z]/}
    return result
  end
  def get_all_tokens_for_state(index)
    result=@FSM[index].keys
    return result
  end
  private
  def is_terminal?(token)
    return token[0]=~/[^A-Z]/
  end
  def is_nonterminal?(token)
    return token[0]=~/[A-Z]/
  end
  def generate_items_sets
    items_set = [Item.new(@rules[0],0)]
    items_set = close_item(items_set)
    @conditions<<Condition.new(items_set, @symbols)
    index = 0
    while index<@conditions.size
      @FSM[index] = {}
      set = @conditions[index]
      if index == 2
        p index
      end
      set.symbols.each do |symbol|
        temp = Condition.new(next_items_set(set.items_sets, symbol, index),@symbols)
        if(temp.items_sets.size>0)
          end_state_index = 0
          if ! @conditions.include?(temp)
            @conditions<< temp
            end_state_index = @conditions.size - 1
          else
            end_state_index = @conditions.index temp
          end
          @FSM[index][symbol] = State.new(ParserAction::SHIFT,end_state_index)
        end
      end
      index +=1
      if index%100 ==0
        p index
      end
    end
    p @conditions
    p @FSM
  end
  def next_items_set(items, x, condition_index)
    @symbols = []
    items_set = []
    items.each do |item|
      if(item.markered ==x)
        if x=='$'
          symbols = follow(item.rule.left)
          symbols.uniq!
          symbols.each{|symbol|
          @FSM[condition_index][symbol]=State.new(ParserAction::REDUCE,0,item.rule)}
          if item.rule == @rules[0]
          @FSM[condition_index][x] = State.new(ParserAction::ACCEPT,0, item.rule)
          end
        else
          temp =  [Item.new(item.rule, item.marker_index+1)]
          items_set+=close_item(temp)
        end

      end
    end
    return items_set
  end
  def close_item(items)
    items.each do |item|
      if(item.rule.right.size>item.marker_index)
        if !(@symbols.include?(item.markered))
          @symbols<<item.markered
        end
        if(is_nonterminal?(item.markered))
          @rules.each do |rule|
            if rule.left == item.markered
              temp = Item.new(rule, 0)
              if !(items.include?(temp))
                items<<temp
              end
            end
          end
        end
      elsif item.rule.right.size==item.marker_index
        @symbols<<'$'
      end
    end
    return items
  end
  def follow(x)
    result = []
    @rules.each do |rule|
      rule.right.each_index  do |element_index|
        if rule.right[element_index] == x
          if rule.right.size>(element_index+1)
            if is_terminal?(rule.right[element_index+1])
              result+=[rule.right[element_index+1]]
            else
              symbols = @symbols
              @symbols = []
              close_item([Item.new(rule, element_index+1)])
              temp = @symbols
              @symbols = symbols
              result+=temp
            end
          else
            result+=['$']
          end
        end
      end
    end
    return result
  end

end


