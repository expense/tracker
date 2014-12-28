class Statement < ActiveRecord::Base

  default_scope { order('time ASC') }

  def parsed_params
    JSON.parse(self.params)
  end

end
