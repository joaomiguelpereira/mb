class StaffersController < UsersController
  
  ########################################
  ### dashboard
  #######################################
  def dashboard
    @staffer = Staffer.find(params[:id])
  end
  
  def availability
  	
  end
  
end
