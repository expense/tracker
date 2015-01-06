class Statement < ActiveRecord::Base

  default_scope { order('time ASC') }

  def parsed_params
    JSON.parse(self.params).with_indifferent_access
  end

  def self.make!(command, params)
    time = params.delete(:time) { Time.now }
    create!(command: command, time: time, params: params.to_json)
  end

end
