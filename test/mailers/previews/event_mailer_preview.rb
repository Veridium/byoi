# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview
    def receipt_email_with_discount
        purchase = Purchase.includes(:invoice).where.not(invoices: {:discount => nil}).first
        user = purchase.invoice.user
        EventMailer.with(user: user, purchase: purchase).receipt_email
    end
    def receipt_email_without_discount
        purchase = Purchase.includes(:invoice).where(invoices: {:discount => nil}).first
        user = purchase.invoice.user
        EventMailer.with(user: user, purchase: purchase).receipt_email
    end
end
