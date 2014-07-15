DEFAULT_SETTINGS = {
  :main_email => "address@domain.tld",
  :per_org_email  => {
      "org_id_1" => "'main' or address@domain.tld",
      "org_id_2" => "'main' or address@domain.tld"
  },
  :time => "05:00",
  :time_zone => "Asia/Jerusalem"
}

def initial_settings(user, orgs)
  # TODO: I’m not sure if this clone is necessary
  # But I don’t really understand Ruby scopes or what changes are visible across
  # threads, so this seems like a good precaution for now
  settings = DEFAULT_SETTINGS.clone

  settings[:main_email] = user.email

  # set per org email to a hash of org id to default email address
  settings[:per_org_email] = Hash[orgs.collect { |org| [org.id.to_s, user.email] }]

  return settings
end
