class ContactMailer < ApplicationMailer
  default from: "noreply@cukee.cloud"

  def new_contact(contact)
    @contact = contact

    mail(
      to: "playwith404@gmail.com",
      subject: "[playwith404 문의] #{contact.inquiry_type_label} - #{contact.name}"
    )
  end
end
