class BusinessAdmin < User
  has_many :businesses, :dependent => :destroy
  #has_many :workers, :dependent=> :destroy
end
