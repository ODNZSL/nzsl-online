# frozen_string_literal: true

class ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :reorder

  before_action :find_or_create_vocab_sheet, :set_search_query, :footer_content
  before_action :set_item, only: %i(update destroy)
  respond_to :html, :json

  def create # rubocop:disable Metrics/AbcSize, MethodLength, Metrics/PerceivedComplexity
    sign_id = params[:sign_id].to_i
    if @sheet.includes_sign?(sign_id: sign_id)
      flash[:notice] = t('vocab_sheet.item.add_duplicate')
    else
      @item = Item.new
      @item.sign = Sign.first(id: sign_id)
      @item.sign_id = sign_id
      @item.name = params[:name].to_s if params[:name]
      @item.maori_name = params[:maori_name].to_s if params[:maori_name]
      @item.position = 1 # added at position one.
      if @item.valid?
        @sheet.items << @item
        flash[:notice] = t('vocab_sheet.item.add_success')
      else
        flash[:error] = t('vocab_sheet.item.add_failure')
      end
    end
    if request.xhr?
      flash[:notice] = flash[:error] = nil
      render partial: 'shared/vocab_sheet_item', locals: { vocab_sheet_item: @item }
    else
      respond_with_json_or_redirect(@item)
    end
  end

  def update # rubocop:disable Metrics/AbcSize
    @item.name = params[:item][:name] if params[:item][:name].present?
    @item.maori_name = params[:item][:maori_name] if params[:item][:maori_name].present?
    if @item.save
      flash[:notice] = t('vocab_sheet.item.update_success')
    else
      flash[:error] = t('vocab_sheet.item.update_failure')
    end
    return respond_with_json_or_redirect(@item) unless request.xhr?

    flash[:notice] = flash[:error] = nil
    render json: @item
  end

  def destroy # rubocop:disable Metrics/AbcSize
    if @item.destroy
      flash[:vocab_bar_notice] = if @sheet.items.length.zero?
                                   t('vocab_sheet.delete_success')
                                 else
                                   t('vocab_sheet.item.remove_success')
                                 end
    else
      flash[:vocab_bar_error] = t('vocab_sheet.item.remove_failure')
    end

    return respond_with_json_or_redirect(@item) unless request.xhr?

    flash[:vocab_bar_notice] = flash[:vocab_bar_error] = nil
    render nothing: true
  end

  def reorder
    params[:items].each_with_index do |id, index|
      # Need to update updated_at column as update_all doesn't do this for some reason
      @sheet.items.where(id: id.to_i).update_all(
        position: index + 1,
        updated_at: Time.current
      )
    end
    render nothing: true
  end

  private

  def set_item
    @item = @sheet.items.find(params[:id])
  end
end
