require_relative 'rule'
require_relative 'grammar'
require_relative 'parser_action'
require_relative 'state'

class Generator
  def initialize(grammar)
    @grammar = grammar
  end
  def generate
    result = []
    stack = [0]
    ready = false
    terminals = @grammar.get_all_terminals_for_state(stack.last)
    token = terminals[rand(terminals.size)]
    state = @grammar.FSM[stack.last][token]
    begin
      state = @grammar.FSM[stack.last][token]
      if state==nil
        result = []
        stack = [0]
        terminals = @grammar.get_all_terminals_for_state(stack.last)
        token = terminals[rand(terminals.size)]
        state = @grammar.FSM[stack.last][token]
      end
      if result.size>500
        raise Exception, 'Posibly we have problems with grammar'
      end
      if(state.type==ParserAction::REDUCE)
        state.rule.right.each_index { |index| stack.pop}
        stack.push @grammar.FSM[stack.last][state.rule.left].number
        terminals = @grammar.get_all_terminals_for_state(stack.last)
        token = terminals[rand(terminals.size)]
      elsif @grammar.FSM[stack.last]['$']!=nil and @grammar.FSM[stack.last]['$'].type==ParserAction::ACCEPT
        ready = true
      else
        stack<<state.number
        if token[0]=~/[^A-Z$]/
          result<<token
        end
        terminals = @grammar.get_all_terminals_for_state(stack.last)
        token = terminals[rand(terminals.size)]
      end

    end while(!ready)
    return result
  end
end
