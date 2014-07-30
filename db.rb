require 'rethinkdb'

include RethinkDB::Shortcuts

module DB

  # TODO: I’m still not sure why this wouldn’t work as a “constant”
  @connection = r.connect(:host=>'localhost', :port=>28015, :db =>'github_digests')

  def self.account_exists?(id)
    account = r.table('accounts').get(id).run(@connection)
    return !!account
  end

  # Creates an account. Returns a hash representing the account.
  # If the account already exists, raises an exception.
  def self.create_account(id, token, settings)
    account = {
      :id => id,
      :token => token,
      :created_at => Time.now.to_i,
      :last_sign_in => Time.now.to_i,
      :settings => settings
    }

    result = r.table('accounts').insert(account).run(@connection)

    if result['inserted'] != 1
      raise 'account already exists'
    end

    # so if we get here, I guess it succeeded... right?
    return account
  end

  def self.get_settings(id)
    account = r.table('accounts').get(id).run(@connection)
    account ? account['settings'] : account
  end

  def self.delete_account(id)
    result = r.table('accounts').get(id).delete().run(@connection)
    if result['deleted'] != 1
      raise 'account not deleted!'
    end
  end
end
