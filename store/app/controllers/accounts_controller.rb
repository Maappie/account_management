class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

def create
  @account = Account.find_by(email: account_params[:email])

  if @account.present?
    if @account.verified?
      flash[:alert] = "Email already exists."
      redirect_to new_account_path and return
    else
      @account.assign_attributes(account_params)
      @account.verification_code = generate_verification_code

      if @account.save
        set_verification_session(@account)
        begin
          AccountMailer.verification_email(@account.email, @account.verification_code).deliver_now
          flash[:notice] = "Verification email sent again. Please verify your account."
          redirect_to verify_account_path and return
        rescue => e
          flash[:alert] = "Sending email failed. Try again."
          redirect_to new_account_path and return
        end
      else
        redirect_to new_account_path and return
      end
    end
  else
    # Not found, create new
    @account = Account.new(account_params)
    @account.verification_code = rand(100000..999999).to_s
    if @account.save
      set_verification_session(@account)
      begin
        AccountMailer.verification_email(@account.email, @account.verification_code).deliver_now
        flash[:notice] = "Verification email sent again. Please verify your account."
        redirect_to verify_account_path and return
      rescue => e
        flash[:alert] = "Sending email failed. Try again."
        redirect_to new_account_path and return
      end
    else
      redirect_to new_account_path and return
    end
  end
end


def resend_email
  @account = Account.find_by(id: session[:account_id])

  if @account.nil?
    flash[:alert] = "Account not found or session expired. Please sign up again."
    redirect_to new_account_path
    return
  end

  if @account.verified?
    flash[:alert] = "Account already verified."
    redirect_to root_path
    return
  end


   begin
          AccountMailer.verification_email(@account.email, @account.verification_code).deliver_now
          flash[:notice] = "Verification email sent again. Please verify your account."
          redirect_to verify_account_path and return
        rescue => e
          flash[:alert] = "Sending email failed. Try again."
          @account = Account.new(account_params)
          render :new and return
        end

  if @account.save
    set_verification_session(@account)

    begin    
      AccountMailer.verification_email(@account.email, @account.verification_code).deliver_now
      flash[:notice] = "Verification email resent. Please check your email."
      redirect_to verify_account_path
    rescue 
    end
    

  else
    flash[:alert] = "Could not resend email. Please try again."
    redirect_to new_account_path
  end
end


def verify_code
end

def process_verification
  input_code = params[:input_verification]
  @account = Account.find_by(id: session[:account_id])

  if session[:verification_code_expires_at].nil? || session[:verification_code_expires_at] < Time.current
    session[:account_id] = nil
    session[:verification_code] = nil
    session[:verification_code_expires_at] = nil

    flash[:alert] = "Verification code has expired. Please sign up again."
    redirect_to new_account_path  
  elsif @account.nil?
    flash.now[:alert] = "Verification failed. Try again."
    render :verify_code
  elsif @account.verification_code == input_code

    if @account.update(verified: true, verification_code: nil) 
      session[:account_id] = nil
      session[:verification_code] = nil
      session[:verification_code_expires_at] = nil
      
      flash[:notice] = "Created account successfully."
      redirect_to root_path
    else
      flash.now[:alert] = "Verification failed. Try again."
      render :verify_code
    end
  else
    flash.now[:alert] = "Incorrect verification code. Please try again."
    render :verify_code
  end
end

def index
  redirect_to new_account_path
end

  private

  def account_params
    params.require(:account).permit(:email, :username, :password, :password_confirmation)
  end

 def set_verification_session(account)
  session[:account_id] = account.id
  session[:verification_code] = account.verification_code
  session[:verification_code_expires_at] = 180.seconds.from_now
end

  def generate_verification_code
    loop do
      code = rand(100000..999999).to_s
        return code unless Account.exists?(verification_code: code)
    end     
  end

end
