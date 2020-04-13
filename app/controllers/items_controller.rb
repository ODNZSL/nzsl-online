# frozen_string_literal: true

class ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :reorder

  before_action :find_or_create_vocab_sheet, :set_search_query, :footer_content
  respond_to :html, :json

  def create
    if @sheet.includes_sign?(sign_id: params[:sign_id])
      flash[:notice] = t('vocab_sheet.item.add_duplicate')
    else
      @item = Item.new(create_params)

      if @item.valid?
        @sheet.add_item(@item)
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

  def update
    @item = @sheet.update_item(update_item_params)

    if @item
      flash[:notice] = t('vocab_sheet.item.update_success')
    else
      flash[:error] = t('vocab_sheet.item.update_failure')
    end

    return respond_with_json_or_redirect(@item) unless request.xhr?

    flash[:notice] = flash[:error] = nil
    render json: @item
  end

  def destroy
    @item = @sheet.destroy_item(params[:id])

    if @item
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
    render json: nil, status: :ok
  end

  def reorder
    @sheet.reorder_items(item_ids: params[:items])
    head :ok
  end

  private

  def create_params
    params.permit(:sign_id)
  end

  def update_item_params
    params.permit(:id, :sign_id, :name, :maori_name, :notes)
  end
end
