class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @content = params[:word]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @books = Book.looks(params[:search], params[:word])
    end
  end
end
