module ApplicationHelper
  
  def more_stylesheets(s)
    content_for :more_stylesheets do
      stylesheet_link_tag s 
    end
    
  end
  
  def title(t)
    
    content_for :title do
      t + " | medibooking.com"
    end
  end
end
