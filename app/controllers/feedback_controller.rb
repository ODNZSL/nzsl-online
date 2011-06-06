class FeedbackController < ApplicationController
  
  before_filter :find_vocab_sheet
  
  def new
    @feedback = Feedback.new
  end
  
  def create
    begin
      @feedback = Feedback.create(params[:feedback])
      if @feedback.valid?
        @feedback.send_email
        @feedback = Feedback.new
        flash[:feedback_notice] = t('feedback.success')
      else
        flash[:feedback_error] = t('feedback.failure')
      end
    rescue
      flash[:feedback_error] = t('feedback.failure')
    end
    render :new
  end
  
end
