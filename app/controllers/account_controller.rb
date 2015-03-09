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
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to({ action: :show }, { notice: 'Account was successfully updated.' }) }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :name, :email)
  end
end
