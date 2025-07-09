class LoginController < ApplicationController
  before_action :require_login, only: [:profile, :logout_account, :admin_account ]



  def account
    account = Account.find_by(email: params[:email])
    account_password = params[:password]

    if account
      if account.password == account_password
        if account.roles == "a" 
          session[:login_id] = account.id
          redirect_to profile_login_path
        else
          session[:login_id] = account.id
          redirect_to admin_account_path
        end
      else
        flash[:notice] = "Password incorrect"
        render :account
      end
    else
      flash[:notice] = "Email incorrect"
      render :account
    end
  end

  def logout_account
    session[:login_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end

  private

  def require_login
    unless session[:login_id]
      flash[:notice] = "Please login first"
      redirect_to root_path
    end
  end
end
