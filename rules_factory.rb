require_relative 'rule'
class RulesFactory
  def to_s(rules)
    result = ''
    rules.each{|rule|
      temp = ''
      rule.right.each{|element| temp+=" #{element}"}
      result+="#{rule.left} -> #{temp};\n"}
    return result
  end
  def load_rules(string)
    regex = /([A-Z][0-9]*) -> (( [A-Za-z][0-9]*)+);/
    rules_string = string.scan(regex)
    result = []
    rules_string.each do |string|
      result<<Rule.new(string[0], string[1].split)
    end
    return result
  end
  def generate_rules(images)
    rules = generate_nonrecursive_grammar(images)
    rules = generate_recursive_grammar(rules)
    rules = delete_similar_rules(rules)
    rules = rename_rules(rules)
    return rules
  end
  private
  def generate_nonrecursive_grammar(images)
    max_images = []
    max_length = 0
    images.each{|image|
    if image.size> max_length
      max_images = []
      max_images<<image
      max_length = image.size
    elsif image.size == max_length
      max_images<<image
    end}
    rules = []
    prev_rule = 1
    p max_images
    max_images.each{|image|
      images.delete(image)
      (0..image.size-3).each do |index|
        if index==0
          rules << Rule.new("S","#{image[index]} A#{prev_rule}".split)
        else
          rules<< Rule.new("A#{prev_rule}","#{image[index]} A#{prev_rule+1}".split)
          prev_rule+=1
        end
      end
      rules<< Rule.new("A#{prev_rule}","#{image[-2]} #{image[-1]}".split)
      prev_rule+=1
    }
    images.each{|image|
      prev = nil
      (0..image.size-2).each do |index|
        if index==0
          temp = exists_rule_like_this(rules,"S","#{image[index]}")
          if temp!=nil
            prev = temp
          else
            rules << Rule.new("S","#{image[index]} A#{prev_rule}".split)
          end
        else
          temp = nil
          if(prev!=nil) and prev.right.size==2
            temp = exists_rule_like_this(rules,prev.right[1],"#{image[index]}")
          end
          if temp!=nil
            prev = temp
          else
            if(prev!=nil) and prev.right.size==2
              rules<< Rule.new(prev.right[1],"#{image[index]} A#{prev_rule}".split)
              else
              rules<< Rule.new("A#{prev_rule}","#{image[index]} A#{prev_rule+1}".split)
              prev_rule+=1
            end

          end
        end
      end

      temp = nil
        if(prev!=nil) and prev.right.size==2
          temp = exists_rule_like_this(rules,prev.right[1],"#{image[-1]}")
        end
        if temp!=nil
          prev = temp
        else
          if(prev!=nil) and prev.right.size==2
            rules<< Rule.new(prev.right[1],["#{image[-1]}"])
          else
            rules<< Rule.new("A#{prev_rule}",["#{image[-1]}"])
            prev_rule+=1
          end

        end
    }
    return rules
  end
  def generate_recursive_grammar(rules)
    rest_nonterms = find_rest_nonterminals(rules)
    p rest_nonterms
    begin
      changes_exists = false
      rules.each do |rule|
        if rule.right.size==2
          rest_nonterms.each do |nonterm|
            if nonterm.right[0]==rule.right[0] and is_ending?(rules, rule.right[1],nonterm.right[1] )
              changes_exists = true
              replace(rules, nonterm.left, rule.left)
              rules.delete nonterm
              rest_nonterms.delete nonterm
            end
          end
        end
      end
    end while(changes_exists)
    return rules
  end
  def delete_similar_rules(rules)
    begin
      changes_exists = false
      rules.each do |rule|
        rules.each do |second_rule|
          if rule!=second_rule and if_the_same? rule, second_rule
            replace(rules, rule.left, second_rule.left)
            rules.delete rule
            changes_exists = true
          end
        end
      end
    end while(changes_exists)
    return rules
  end
  def rename_rules (rules)
    names = []
    rules.each do |rule|
      names<<rule.left
    end
    names.uniq!
    names.each_index{|name_index|
      replace rules, names[name_index], "B#{name_index+1}"
    }
    rules.unshift Rule.new('S',%w(B1))
    return rules
  end
  def exists_rule_like_this(rules, left, first_part)
    result = nil
    rules.each{|rule|
      if rule.left == left and rule.right[0]==first_part
        return rule
      end
    }
    return result
  end
  def find_rest_nonterminals(rules)
    result = rules.select{|rule|
      rule.right.size==2 and rule.right[0]=~/[a-z]/ and  rule.right[1]=~/[a-z]/
    }
    return result
  end
  def is_ending?(rules, left, right)
      result = false
      rules.each{|rule|
      if rule.left == left and rule.right.size==1 and rule.right[0] ==right
        result = true
        break
      end}
      return result
  end
  def replace(rules, before, after)
    rules.each_index{|index|
      if rules[index].right.size==2 and rules[index].right[1]==before
        rules[index].right[1]=after
      end
      if rules[index].left == before
        rules[index].left = after
      end
    }
  end
  def if_the_same?(first, second)
    result = true
    if first.right.size==second.right.size
      (0..first.right.size).each do |index|
        if first.right[index]!=second.right[index]
          result = false
        end
      end
    else
      result= false
    end
    return result
  end
end

factory = RulesFactory.new
images = %w(caaab bbaab caab bbab cab bbb cb)
factory.generate_rules(images)