class Lexeme
  attr_accessor :value,
                :type
  def initialize(type, value='')
    @value = value
    @type = type
  end
  def is_id?
    return @type=='id'
  end
  def is_string?
    return @type=='stringLiteral'
  end
  def is_number?
    return @type=='numberLiteral'
  end
  def if_separator?
    return @type=='separator'
  end
  def is_char?
    return @type=='charLiteral'
  end
end