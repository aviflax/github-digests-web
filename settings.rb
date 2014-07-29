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
      :main => "avi@aviflax.com",
      :additional => [
        "avif@arc90.com",
        "avif@sfxii.com"
      ]
    }
}

def initial_settings(user, orgs)
  # TODO: I’m not sure if this clone is necessary
  # But I don’t really understand Ruby scopes or what changes are visible across
  # threads, so this seems like a good precaution for now
  settings = DEFAULT_SETTINGS.clone
  settings[:per_org_email] = orgs.map { |org| {:id=>org.id, :name=>org.login, :email=>'default'} }
  return settings
end
