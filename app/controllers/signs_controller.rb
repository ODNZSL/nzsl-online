class SignsController < ApplicationController

  def search
    @signs = Sign.all(params)
  end

  def show
    @sign = Sign.first({:id => params[:id]})
  end

end

