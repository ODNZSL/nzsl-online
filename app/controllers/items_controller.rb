class ItemsController < ApplicationController

  before_filter :find_or_create_vocab_sheet

  def create
    @item = Item.new
    @item.sign = Sign.first({:id => params[:sign_id]}) if params[:sign_id]
    @item.name = params[:name].to_s if params[:name]

    if @item.valid?
      @sheet.items << @item
      flash[:notice] = t('vocab_sheet.item.add_success')
      redirect_to vocab_sheet_url
    else
      flash[:error] = t('vocab_sheet.item.add_failure')
      redirect_back_or_default
    end
  end

  def destroy
    if @item = @sheet.items.destroy(params[:id])
      flash[:notice] = t('vocab_sheet.item.remove_success')
    else
      flash[:error] = t('vocab_sheet.item.remove_failure')
    end

    redirect_back_or_default
  end
end

