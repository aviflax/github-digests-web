DEFAULT_SETTINGS = {
    :default_email => "primary",
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
      :primary => "whatever@domain.tld",
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
  settings[:emails] = emails_to_hash(emails)
  return settings
end

# Accepts an emails hash as returned by GitHub and converts it to the hash
# structure expected by this app. The resulting hash contains only verified
# email addresses. Useful when creating initial settings for a
# new account and when updating the :emails key of an existing Account.
def emails_to_hash(emails)
  {
    :primary => emails.find { |email| email.primary }.email,
    :additional => emails.select { |email| !email.primary && email.verified}.map { |email| email.email }
  }
end
