class FeedbackController < ApplicationController
  def new
    @feedback = Feedback.new
  end
  
  def create
    begin
      @feedback = Feedback.create(params[:feedback])
      
      if @feedback.valid?
        @feedback.send_email
        redirect_to root_path and return
      else
        redirect_to new_feedback_path and return
      end
    rescue
     redirect_to(new_feedback_path) and return
    end
  end
  
end
