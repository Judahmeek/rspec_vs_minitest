def log_in_as(user, options = {})
  password		= options[:password]		|| 'password'
  remember_me = options[:remember_me]	|| '1'
  if defined?(post_via_redirect)
  	post login_path, session: { email:      user.email,
  								              password:   password,
  								              remember_me: remember_me }
  else
	  session[:user_id] = user.id
  end
end