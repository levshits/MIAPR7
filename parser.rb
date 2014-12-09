require_relative 'syntax_tree_node'
require_relative 'lexeme'
require_relative 'rule'
require_relative 'grammar'
require_relative 'parser_action'
require_relative 'state'

class GrammarParser
  def initialize(grammar)
    @parser_stack = []
    @grammar = grammar
  end
  def parse?(tokens)
    token_list = tokens.each
    token = token_list.next
    accepted = false
    @parser_stack = [0]
    while(!accepted)
      state = @grammar.FSM[@parser_stack.last][token]
      if state == nil
        break;
      end
      case state.type
        when ParserAction::ACCEPT
          accepted = true
        when ParserAction::SHIFT
          token = token_list.next
          @parser_stack.push(state.number)
        when ParserAction::REDUCE
          #add element to tree
          element = []
          state.rule.right.each_index { |index| element<<@parser_stack.pop}
          @parser_stack.push(@grammar.FSM[@parser_stack.last][state.rule.left].number)
      end
    end
    return accepted
  end
end

