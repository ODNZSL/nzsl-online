class ItemsController < ApplicationController

  before_filter :find_or_create_vocab_sheet
  respond_to :html, :json

  def create
    if @sheet.items.any?{|i| i.sign_id == params[:sign_id].to_i}
      flash[:notice] = t('vocab_sheet.item.add_duplicate')
    else
      @item = Item.new
      @item.sign = Sign.first({:id => params[:sign_id]}) if params[:sign_id]
      @item.name = params[:name].to_s if params[:name]
      if @item.valid?
        @sheet.items << @item
        flash[:error] = t('vocab_sheet.item.add_success')
      else
        flash[:error] = t('vocab_sheet.item.add_failure')
      end
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
      if @sheet.items.length.zero?
        flash[:vocab_bar_notice] = t('vocab_sheet.delete_success')
      else
        flash[:vocab_bar_notice] = t('vocab_sheet.item.remove_success')
      end
    else
      flash[:vocab_bar_error] = t('vocab_sheet.item.remove_failure')
    end
    respond_with_json_or_redirect(@item)
  end

  def reorder
    params[:items].each_with_index do |id, index|
      #Need to update updated_at column as update_all doesn't do this for some reason
      @sheet.items.where(:id => id.to_i).update_all(
        :position => index + 1,
        :updated_at => Time.now
      )
    end
    render :nothing => true
  end
end

