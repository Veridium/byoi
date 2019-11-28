class EventMailer < ApplicationMailer
    def receipt_email
        @user = params[:user]
        @purchase  = params[:purchase]
        mail(to: @user.email, subject: 'Your GBA Id credential receipt')
    end
end
