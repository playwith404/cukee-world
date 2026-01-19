class ContactMailer < ApplicationMailer
  default from: ENV.fetch("MAILER_FROM_EMAIL", "noreply@cukee.world")

  def new_contact(contact)
    @contact = contact

    mail(
      to: ENV.fetch("CONTACT_EMAIL", "playwith404@gmail.com"),
      subject: "[playwith404 문의] #{contact.inquiry_type_label} - #{contact.name}"
    )
  end
end
