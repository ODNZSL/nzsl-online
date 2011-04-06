class SignsController < ApplicationController

  def landing
    @sign = Sign.first({:random => 1})
  end

  def search
    if params[:page]
      @num_of_results, @signs = Sign.paginate(session[:search][:query], params[:page].to_i)
    else
      @num_of_results, @signs = Sign.paginate(params[:search])
    end
    store_query
  end

  def show
    @sign = Sign.first({:id => params[:id]})
  end


  private

  def store_query
    session[:search] = {:count => @num_of_results, :query => params[:search]}
  end


end

