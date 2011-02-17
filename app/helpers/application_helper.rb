module ApplicationHelper
  
  def more_stylesheets(s)
    content_for :more_stylesheets do
      stylesheet_link_tag s 
    end
    
  end
  
  def more_javascripts_files(j) 
    content_for :more_javascripts_files do
      javascript_include_tag j 
    end
    
  end
  def title(t)
    
    content_for :title do
      t + " | medibooking.com"
    end
  end
  def boolean_to_yes_no(val)
    return I18n.t "general_words.positive" if val
    return I18n.t "general_words.negative"
  end
  def errors_for(object, attribute, show_all=false)
    errors = object.errors[attribute]
    if errors.size>0
      errors = [errors] unless errors.is_a?(Array)
      
      return "<div class='error'>"+errors[0]+"</div>" unless show_all
      
      return errors.map {|e|  "<div class='error'>" + e + "</div>" }.join if show_all
    end
  end
end
