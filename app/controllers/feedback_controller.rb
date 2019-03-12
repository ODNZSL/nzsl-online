# frozen_string_literal: true

class FeedbackController < ApplicationController
  before_action :find_vocab_sheet, :set_search_query, :footer_content

  def new
    @feedback = Feedback.new
  end

  def create
    process_feedback

    @feedback = Feedback.new
    @page = Page.find(params[:page_id].to_i)
    @title = @page.title

    render template: "pages/#{@page.template}"
  end

  private

  def process_feedback
    feedback = Feedback.create(feedback_params)

    if feedback.valid?
      feedback.send_email
      flash.now[:feedback_notice] = t('feedback.success')
    else
      flash.now[:feedback_error] = t('feedback.failure')
    end
  rescue StandardError
    flash.now[:feedback_error] = t('feedback.failure')
  end

  def feedback_params
    params.require(:feedback).permit(:name, :message, :video, :email)
  end
end
