class Availability < ActiveRecord::Base
 
  #Class constants
  WEEK_DAYS = 7.freeze
  START_HOUR_FIELD_NAME = "startHour".freeze
  END_HOUR_FIELD_NAME = "endHour".freeze
  WEEK_DAY_FIELD_NAME = "weekDay".freeze
  belongs_to :business_account
  
  after_create :create_default_json_data
  
  
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
    self.json_data = def_json_data.to_json
    self.save
  end
end
