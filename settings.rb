DEFAULT_SETTINGS = {
    :default_email => "main",
    :per_org_email  => [
        {
          :id => 12345,
          :name => "Arc90",
          :email => "'default' or address@domain.tld"
        }
    ],
    :hour => "05:00",
    :time_zone => "Asia/Jerusalem",
    :emails => {
      :main => "whatever@domain.tld",
      :additional => [
        "whatever@domain.tld",
        "whatever@domain.tld"
      ]
    }
}

def initial_settings(user, orgs, emails)
  # TODO: I’m not sure if this clone is necessary
  # But I don’t really understand Ruby scopes or what changes are visible across
  # threads, so this seems like a good precaution for now
  settings = DEFAULT_SETTINGS.clone
  settings[:per_org_email] = orgs.map { |org| {:id=>org.id, :name=>org.login, :email=>'default'} }
  add_emails(settings, emails)
end

# Accepts a settings hash and a user and adds the user’s current email addresses
# to the settings hash. Useful for refreshing the email addresses present in a
# settings object. Returns the settings hash.
def add_emails(settings, emails)
  settings[:emails] = {
    :main => emails.find { |email| email.primary }.email,
    :additional => emails.select { |email| !email.primary && email.verified}.map { |email| email.email }
  }
  settings
end
