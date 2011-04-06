class ItemsController < ApplicationController

  before_filter :find_or_create_vocab_sheet
  respond_to :html, :json

  def create
    @item = Item.new
    @item.sign = Sign.first({:id => params[:sign_id]}) if params[:sign_id]
    @item.name = params[:name].to_s if params[:name]

    if @item.valid?
      @sheet.items << @item
      flash[:notice] = t('vocab_sheet.item.add_success')
    else
      flash[:error] = t('vocab_sheet.item.add_failure')
    end
    respond_with_json_or_redirect(@item)
  end

  def update
    @item = Item.find(params[:id])
    @item.name = params[:item][:name]
    if @item.save
      flash[:notice] = t('vocab_sheet.item.update_success')
    else
      flash[:notice] = t('vocab_sheet.item.update_failure')
    end
    respond_with_json_or_redirect(@item)
  end

  def destroy
    if @item = @sheet.items.find(params[:id]).destroy
      flash[:notice] = t('vocab_sheet.item.remove_success')
    else
      flash[:error] = t('vocab_sheet.item.remove_failure')
    end
    respond_with_json_or_redirect(@item)
  end

  def reorder
    params[:items].each_with_index do |id, index|
      #Need to update updated_at column as update_all doesn't do this for some reason
      @vocab_sheet.items.where(:id => id.to_i).update_all(
        :position => index + 1,
        :updated_at => Time.now
      )
    end
    render :nothing => true
  end
end

