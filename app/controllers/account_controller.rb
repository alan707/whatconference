class AccountController < ApplicationController
  # Make sure user is signed in
  before_filter :authenticate_user!
  before_filter :set_user

  exposes :user
  
  # GET /account
  def show
  end

  # POST /account
  def update
  end

  private

  def set_user
    @user = current_user
  end
end
