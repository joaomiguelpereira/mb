class Speciality < ActiveRecord::Base
  
    
  validates :name, :presence=>true, 
                         :length=>{:minimum=>2, :maximum=>128},
                         :uniqueness=>true,
                         :format=>/^[A-Za-z\d_]+$/
  
end
