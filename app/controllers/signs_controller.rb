class SignsController < ApplicationController

  def landing
    @sign = Sign.first({:random => 1})
  end

  def search
    @signs = Sign.all(params[:search])
  end

  def show
    @sign = Sign.first({:id => params[:id]})
  end


end

