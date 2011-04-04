class VocabSheetController < ApplicationController

  before_filter :find_or_create_vocab_sheet

  def update
    @sheet.items << Item.new(
      :sign => Sign.first(params[:id]),
      :name => params[:name],
    )
  end

  def destroy_item
    @sheet.items.delete_if { |item| item.sign_id = params[:id] }
  end

  def destroy
    #Clear the sheet and mark as deletable
    @sheet.items = []
    @sheet.update_attribute(:display, false)
  end

  private

  def find_or_create_vocab_sheet
    @sheet = VocabSheet.find(session[:vocab_sheet_id])
    @sheet ||= VocabSheet.create
    session[:vocab_sheet_id] = @sheet.id
  end
end

