require_relative 'terminal_element'
require_relative 'line'
require 'tk'
class TerminalsFactory
  def initialize
    @terminals_types = {'t'=>[0,-10], 'b'=>[0,10], 'r'=>[10,0], 'l'=>[-10,0]}

  end
  def made_terminals(list)
    result = []
    list.each do |element|
      type = @terminals_types[element]
      result<<Line.new(type[0], type[1])
    end
    return result
  end
  def draw_terminals(list, canvas)
    @x = canvas.winfo_width/2
    @y = canvas.winfo_height/2
    list.each do |terminal|
      terminal.draw(canvas,@x, @y)
      temp = terminal.get_end_point
      @x+=temp[0]
      @y+=temp[1]
    end
  end
  def reset
    @x = nil
    @y = nil
  end
  def draw_terminals_manualy(canvas, type)
    if @x == nil
      @x = canvas.winfo_width/2
      @y = canvas.winfo_height/2
    end
    type = @terminals_types[type]
    result=Line.new(type[0], type[1])
    result.draw(canvas,@x, @y)
    temp = result.get_end_point
    @x+=temp[0]
    @y+=temp[1]
  end
end