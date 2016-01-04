# route handlers dealing with the collection
get '/entries' do
  @entries = Entry.most_recent
  erb :'entries/index'
end

post '/entries' do
  user = User.find_by_username(session[:user])
  @entry = user.entries.new(params[:entry])
  if @entry.save
    redirect "/entries/#{@entry.id}"
  else
    @errors = @entry.errors.full_messages
    erb :'entries/new'
  end
end

get '/entries/new' do
  if !(session[:user])
    redirect '/404'
  end
  erb :'entries/new'
end

get '/404' do
  erb :'404'
end


# route handlers dealing with a specific entry
before '/entries/:id' do
  find_and_ensure_entry
end

get '/entries/:id' do
  erb :'entries/show'
end

get '/users/:id/entries' do
  redirect '/404' if !(User.where(id: params[:id]).any?)
  @entries = Entry.where(user_id: params[:id])
  erb :'entries/index'
end

put '/entries/:id' do
  @entry.assign_attributes(params[:entry])

  if @entry.save
    redirect "entries/#{@entry.id}"
  else
    @errors = @entry.errors.full_messages
    erb :'entries/edit'
  end
end

delete '/entries/:id' do
  if ( session[:user] == User.find(@entry.user_id).username )
    @entry.destroy
    redirect '/entries'
  else
    erb:'404'
  end
end

get '/entries/:id/edit' do
  @entry = Entry.find(params[:id])
  if ( session[:user] == User.find(@entry.user_id).username )
    find_and_ensure_entry
    erb :'entries/edit'
  else
    erb:'404'
  end
end
