class ChatController < ApplicationController

  def index
  end

  def chat
    text = params[:text]
    time = if params[:time]
             Time.at(params[:time].to_i / 1000.0) or Time.now
           else
             Time.now
           end
    raise "no text" unless text.present?
    @response = Chat.new(text, time).send
    respond_to do |format|
      format.html { render :index }
      format.json { render json: { response: @response } }
    end
  end

end

