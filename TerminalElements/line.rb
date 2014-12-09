require_relative 'terminal_element'
require 'tk'
class Line < TerminalElement
  def initialize(x,y)
    @x_lenght = x
    @y_lenght = y
  end
  def get_end_point
    return [@x_lenght, @y_lenght]
  end
  def draw(canvas,x,y)
    @line = TkcLine.new(canvas,x,y,x+@x_lenght, y+@y_lenght) do
      fill 'red'
      width 2
    end
  end
end