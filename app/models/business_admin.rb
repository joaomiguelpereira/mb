class BusinessAdmin < User
  has_many :businesses, :dependent => :destroy
  has_many :staffers, :dependent=> :destroy
end
