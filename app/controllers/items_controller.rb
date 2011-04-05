class ItemsController < ApplicationController

  before_filter :find_or_create_vocab_sheet

  def create
    @item = Item.new
    @item.sign = Sign.first({:id => params[:sign_id]}) if params[:sign_id]
    @item.name = params[:name].to_s if params[:name]

    if @item.valid?
      @sheet.items << @item
      redirect_to vocab_sheet_url
    else
      redirect_back_or_default
    end
  end

  def destroy
    debugger
    @sheet.items.select { |item| item.id = params[:id] }.each(&:destroy)
    redirect_back_or_default
  end
end

