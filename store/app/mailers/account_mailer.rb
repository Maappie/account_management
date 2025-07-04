class AccountMailer < ApplicationMailer
  default from: 'renzmapa0321@gmail.com'

  def verification_email(email, code)
    @code = code
    mail(to: email, subject: 'Verification Code')
  end
end
