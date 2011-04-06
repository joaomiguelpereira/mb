class Availability < ActiveRecord::Base
  
  #Class constants
  WEEK_DAYS = 7.freeze
  START_HOUR_FIELD_NAME = "startHour".freeze
  END_HOUR_FIELD_NAME = "endHour".freeze
  WEEK_DAY_FIELD_NAME = "weekDay".freeze
  
  EXCEPTION_START_DATE_FIELD_NAME = "startDate".freeze
  EXCEPTION_END_DATE_FIELD_NAME = "endDate".freeze
  EXCEPTION_MOTIVE_FIELD_NAME = "motive".freeze
  EXCEPTION_NOTES_FIELD_NAME = "notes".freeze
  belongs_to :business_account
  
  after_create :create_default_json_data
  
  def self.is_exceptions_json_valid?(json)
    return false if json.nil? || json.empty?
    parsed_json = ActiveSupport::JSON.decode(json)
    #must be an array
    return false if !parsed_json.kind_of?(Array)
    
    parsed_json.each do |ex|
      return false if !is_valid_exception?(ex)        
    end
    
    true
  end
  
  def self.is_valid_exception?(exception) 
    
    #check the presence of the required fields...
    return false if  (exception[EXCEPTION_START_DATE_FIELD_NAME].nil? || exception[EXCEPTION_END_DATE_FIELD_NAME].nil? || exception[EXCEPTION_MOTIVE_FIELD_NAME].nil?)    
    
    start_date = Date.strptime(exception[EXCEPTION_START_DATE_FIELD_NAME], "%d/%m/%Y")
    end_date = Date.strptime(exception[EXCEPTION_END_DATE_FIELD_NAME], "%d/%m/%Y")
    
    
    return false if ( start_date > end_date )
    
    true
  rescue ArgumentError
    logger.error("Error convertin dates.")
    false
    
  end
  
  def self.is_json_valid?(json)
    #convert back json to an array
    return false if json.nil? || json.empty?
    parsed_json = ActiveSupport::JSON.decode(json)
    return false if !parsed_json.kind_of?(Array)
    ##Length 
    return false if parsed_json.length != WEEK_DAYS
    parsed_json.each do |el|
      return false if !el.kind_of?(Array)
      el.each do |ev|
        return false if (ev[START_HOUR_FIELD_NAME].nil? || ev[END_HOUR_FIELD_NAME].nil? || ev[WEEK_DAY_FIELD_NAME].nil?)        
      end
    end
    
    true
  end
  private 
  def create_default_json_data
    def_json_data = Array.new
    for i in (0..6)
      day_array = Array.new
      def_json_data << day_array
    end
    exceptions_array = Array.new
    self.exceptions_json_data = exceptions_array.to_json
    self.json_data = def_json_data.to_json
    self.save
  end
end
