require 'tk'
require_relative 'grammar'
require_relative 'generator'
require_relative 'parser'
require_relative 'rule'
require_relative 'TerminalElements/terminals_factory'
require_relative 'rules_factory'

class Main
  def initialize
    @elements = []
    @root = TkRoot.new('title'=>'methodology of decision-making') do
      minsize(600,400)
    end
    prepare_grammar
    create_ui
    bind_ui_elements
  end
  def run
    Tk.mainloop
  end
  private
  def prepare_grammar
    @rules = []
    @rules <<  Rule.new('S',%w(N))
    @rules <<  Rule.new('N',%w(V t E))
    @rules <<  Rule.new('N',%w(N l T b))
    @rules <<  Rule.new('N',%w(F b b T b))
    @rules <<  Rule.new('E',%w(V t))
    @rules <<  Rule.new('E',%w(V))
    @rules <<  Rule.new('E',%w(H))
    @rules <<  Rule.new('V',%w(r t))
    @rules <<  Rule.new('V',%w(l t V))
    @rules <<  Rule.new('H',%w(l r V r))
    @rules <<  Rule.new('F',%w(V b b E))
    @rules <<  Rule.new('X',%w(F t F l b E T))
    @rules <<  Rule.new('T',%w(b t))
    @rules_factory = RulesFactory.new
    @grammar  = Grammar.new(@rules)
    @parser = GrammarParser.new( @grammar)
    @generator = Generator.new(@grammar)
    @factory = TerminalsFactory.new
  end
  def create_ui
    control_frame = TkFrame.new(@root) do
      pack('fill'=>'x')
      background 'blue'
      pady 10
      padx 10
    end
    @syntes_button = TkButton.new(control_frame, 'text'=>'Syntez') do
      pack('side'=>'left')
    end
    @syntesgroup_button = TkButton.new(control_frame, 'text'=>'Syntez group') do
      pack('side'=>'left')
    end
    @analyz_button = TkButton.new(control_frame, 'text'=>'Analyz') do
      pack('side'=>'left')
    end
    @clear_button = TkButton.new(control_frame, 'text'=>'Clear') do
      pack('side'=>'left')
    end
    frame = TkFrame.new(@root) do
      pack('fill'=>'both', 'expand'=>'yes')
      end
    canvas_frame = TkFrame.new(frame) do
      pack('fill'=>'both', 'expand'=>'yes', 'side'=>'left')
      background 'green'
      pady 5
      padx 5
    end
    grammar_frame = TkFrame.new(frame) do
      pack('fill'=>'y','side'=>'right')
      background 'green'
      pady 5
      padx 5
    end
    @grammar_textbox = TkText.new(grammar_frame) do
      pack('fill'=>'y', 'expand'=>'yes')
      width 30
    end
    @grammar_textbox.value = @rules_factory.to_s @rules

    @grammar_confirm_button = TkButton.new(grammar_frame, 'text'=>'Confirm') do
      pack()
    end
    @grammar_images = TkText.new(grammar_frame) do
      pack()
      height 5
      width 30
    end
    @grammar_generate_button = TkButton.new(grammar_frame, 'text'=>'Generate') do
      pack()
    end
    @canvas = TkCanvas.new(canvas_frame) do
      pack('fill'=>'both', 'expand'=>'yes')
      background 'black'
    end
  end
  def bind_ui_elements
    @syntes_button.bind('1', proc{syntes_button_click})
    @syntesgroup_button.bind('1', proc{syntesgroup_button_click})
    @analyz_button.bind('1', proc{analyz_button_click})
    @clear_button.bind('1',proc{clear_button_click})
    @grammar_confirm_button.bind('1', proc{confirm_button_click})
    @grammar_generate_button.bind('1', proc{generate_button_click})
    @root.bind('KeyPress-Up', proc{
                       @elements<<'t'
                       @factory.draw_terminals_manualy(@canvas,'t')})
    @root.bind('KeyPress-Down', proc{
                                @elements<<'b'
                                @factory.draw_terminals_manualy(@canvas,'b')})
    @root.bind('KeyPress-Left', proc{
                              @elements<<'l'
                              @factory.draw_terminals_manualy(@canvas,'l')})
    @root.bind('KeyPress-Right', proc{
                                @elements<<'r'
                                @factory.draw_terminals_manualy(@canvas,'r')})
  end
  def syntes_button_click
    @elements = @generator.generate
    @canvas.delete('all')
    ui_terminals = @factory.made_terminals(@elements)
    @factory.draw_terminals(ui_terminals,@canvas)
  end
  def syntesgroup_button_click
    50.times {
    @elements = @generator.generate
    @canvas.delete('all')
    ui_terminals = @factory.made_terminals(@elements)
    @factory.draw_terminals(ui_terminals,@canvas)
    Tk.update_idletasks
    Tk.sleep(500)}
  end
  def analyz_button_click
    message = ''
    p @elements
    if @parser.parse?(@elements+['$'])
      message = 'Image is correct'
    else
      message = 'Image is wrong'
    end
      Tk.messageBox(
          'type'    => "ok",
          'icon'    => "info",
          'title'   => "Info",
          'message' => message)

  end
  def clear_button_click
    @canvas.delete('all')
    @elements = []
    @factory.reset
  end
  def confirm_button_click
    @rules = @rules_factory.load_rules(@grammar_textbox.value)
    @grammar = Grammar.new(@rules)
    @parser = GrammarParser.new( @grammar)
    @generator = Generator.new(@grammar)
  end
  def generate_button_click
    images = @grammar_images.value.scan /[a-z]+/
    rules = @rules_factory.generate_rules(images)
    @grammar_textbox.value = @rules_factory.to_s(rules)
  end
end
program = Main.new
program.run