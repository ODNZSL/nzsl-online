class FeedbackController < ApplicationController
  before_action :find_vocab_sheet, :set_search_query, :footer_content

  def new
    @feedback = Feedback.new
  end

  def create # rubocop:disable Metrics/AbcSize
    begin
      @feedback = Feedback.create(feedback_params)
      if @feedback.valid?
        @feedback.send_email
        @feedback = Feedback.new
        flash.now[:feedback_notice] = t('feedback.success')
      else
        flash.now[:feedback_error] = t('feedback.failure')
      end
    rescue StandardError
      flash.now[:feedback_error] = t('feedback.failure')
    end
    @page = Page.find(params[:page_id].to_i)
    @title = @page.title
    render template: "pages/#{@page.template}"
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :message, :video, :email)
  end
end
