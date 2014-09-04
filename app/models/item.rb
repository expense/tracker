class Item < ActiveRecord::Base

  validates_presence_of :command
  default_scope { order('created_at ASC') }

  def info
    if @saved_command != command
      @saved_command = command
      @info_instance = nil
    end
    @info_instance ||= Info.parse(@saved_command)
  end

  def description
    "[#{id}] #{info}#{comment.present? ? " (#{comment})" : ''} @ #{self.when}"
  end

  def export
    "#{command} @ #{created_at.to_formatted_s}#{comment.present? ? " # #{comment}" : ""}"
  end
  
  def when
    created_at.to_formatted_s(:j)
  end

  scope :today, -> { where('created_at >= ?', Date.today.begin) }
  scope :on, -> date { where('created_at >= ?', date.begin).where('created_at < ?', (date + 1.day).begin) }

end
