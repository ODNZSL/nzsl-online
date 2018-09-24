# frozen_string_literal: true

class VocabSheetsController < ApplicationController
  before_action :set_vocab_sheet, only: :destroy
  before_action :find_or_create_vocab_sheet, :set_title, except: :destroy
  before_action :set_search_query, :footer_content
  respond_to :html, :json

  def show
    set_vocab_sheet_size

    respond_to do |format|
      format.html do
        return render :print if params[:print] == 'true'
        render :show
      end

      format.pdf do
        pdf = build_rendered_pdf(html: render_to_string(:print, formats: [:html]))
        send_file(pdf.file_path, filename: pdf.download_as_filename(@title), type: pdf.mime_type)
      end
    end
  end

  def update
    @sheet.name = params[:vocab_sheet][:name]
    if @sheet.save
      flash[:notice] = t('vocab_sheet.sheet.update_success')
    else
      flash[:error] = t('vocab_sheet.sheet.update_failure')
    end

    return respond_with_json_or_redirect(@sheet) unless request.xhr?

    flash[:notice] = flash[:error] = nil
    render json: @sheet
  end

  def destroy
    if @sheet&.destroy
      session[:vocab_sheet_id] = nil
      flash[:notice] = t('vocab_sheet.delete_success')
    else
      flash[:error] = t('vocab_sheet.delete_failure')
    end
    redirect_back_or_default
  end

  private

    def set_vocab_sheet
      # session object isn't available in the parent controller scope
      session[:vocab_sheet_id] = params[:id] if session[:vocab_sheet_id].blank?
      @sheet = VocabSheet.find_by(id: session[:vocab_sheet_id])
    end

    def set_title
      @title = @sheet.name
    end

    def build_rendered_pdf(html:)
      renderer = PdfRenderingService.new(from_html: html)
      renderer.render
      renderer.pdf
    end

    def set_vocab_sheet_size
      @size = params[:size].to_i
      @size = session[:vocab_sheet_size].to_i if @size.zero?
      @size = 4 if @size.zero?
      session[:vocab_sheet_size] = @size
    end
end
