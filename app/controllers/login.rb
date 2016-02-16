get '/register' do
  erb :"users/register"
end

get '/register/check' do
  user = User.new(username: params[:username], email: params[:email])
  user.password=(params[:password])
  user.save
  if user.errors.messages[:username] || user.errors.messages[:email]
    @username_error = "that username's already taken" if user.errors[:username].any?
    @email_error = "that email's already registered" if user.errors[:email].any?
    erb :"users/register"
  else
    session["user"] = user.username
    redirect '/entries'
  end
end

get '/login' do
  erb :"users/login"
end

get '/login/check' do
  user = User.find_by_email(params[:email])
  p user
  if !(user)
    @email_error = "There's no user with that email"
    erb :"users/login"
  elsif user.password != params[:password]
    @password_error = "wrong password, try again"
    erb :"users/login"
  else
    session["user"] = user.username
    redirect '/entries'
  end
end

get '/logout' do
  session['user'] = nil
  redirect '/entries'
end
