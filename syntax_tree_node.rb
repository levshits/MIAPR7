require_relative 'lexeme'
class SyntaxTreeNode<Lexeme
  attr_accessor :type,
                :value,
                :child_nodes
  def initialize(type, value, childs = [])
    @type = type
    @value = value
    @child_nodes = childs
  end
end