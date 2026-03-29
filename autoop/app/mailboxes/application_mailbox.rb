class ApplicationMailbox < ActionMailbox::Base
  routing(/invoices@/i => :invoices)
  routing(/invoice@/i  => :invoices)
  routing(:all          => :invoices)
end
