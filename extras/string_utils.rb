
class StringUtils
  
  def self.generate_random_string(size=50)
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;  
     (0..size).map{ o[rand(o.length)]  }.join;
  end
end  
