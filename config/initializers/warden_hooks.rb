Warden::Manager.after_authentication do |user, auth, opts|
  # deviseでのログインが成功した直後に実行

  LoginHistory.find_or_create_by(user: user, logged_in_on: Date.today)
end