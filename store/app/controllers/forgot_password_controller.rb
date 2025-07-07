class ForgotPasswordController < ApplicationController
  def new
  end

  def create
    account = Account.find_by(email: params[:email])

    if account && account.verified == true
      session[:verification_code] = generate_verification_code
      session[:verification_code_expires_at] = 210.seconds.from_now
     
      if account.update(verification_code: session[:verification_code])
        begin
          AccountMailer.verification_email(account.email, account.verification_code).deliver_now
          
          redirect_to verify_code_forgot_password_index_path
          flash[:alert] = "Verification sent."
        rescue => e 
          flash[:alert] = "Sending email failed. Try again."
          redirect_to new_forgot_password_path
        end
      else
        flash[:alert] = "Failed to update account. Try again."
        redirect_to new_forgot_password_path
      end
    else
      flash[:alert] = "Email not found"
      redirect_to new_forgot_password_path	
    end
  end

  def process_verification
    input_code = params[:input_code]
    account = Account.find_by(verification_code: session[:verification_code])

    if account.nil?
      flash[:notice] = "Verification expired."
      session[:verification_code] = nil
      session[:verification_code_expires_at] = nil

      redirect_to new_forgot_password_path
    end

    if session[:verification_code_expires_at] == nil || session[:verification_code_expires_at] < Time.current
      flash[:notice] = "Verification expired."
      session[:verification_code] = nil
      session[:verification_code_expires_at] = nil

      redirect_to new_forgot_password_path	
      return
    end

    if account && account.verification_code == input_code
      session[:reset_password_id] = account.id
      session[:verification_code] = nil
      session[:verification_code_expires_at] = nil

      redirect_to update_password_forgot_password_index_path
    else
      flash[:alert] = "Verification code incorrect. Try again."
     redirect_to verify_code_forgot_password_index_path
    end
  end

  def update_password
    @account = Account.new
  end

  def process_update_password
    @account = Account.find_by(id: session[:reset_password_id])

    if @account.id.present?
      if @account.update(new_password_params.merge(verification_code: nil))
        flash[:notice] = "Password changed successfully."
        session[:reset_password_id] = nil
        redirect_to root_path
      else
        flash[:notice] = @account.errors.full_messages.join(", ")
        redirect_to update_password_forgot_password_index_path
      end
    else
      flash[:notice] = "Password change failed."
      redirect_to update_password_forgot_password_index_path
    end
  end

  private

  def new_password_params
   params.require(:account).permit(:password, :password_confirmation)
  end

  def generate_verification_code
    loop do
      code = rand(100000..999999).to_s
        return code unless Account.exists?(verification_code: code)
    end     
  end
  
end

