require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require './models'
require 'active_support/core_ext/object/try'

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end

before do
  Dotenv.load
  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUD_NAME']
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
  end
end

get '/' do
  erb :load
end

get '/top' do
  @contributions = Contribution.all

  erb :index
end

get '/signup' do
  erb :sign_up
end

get '/signin' do
  erb :sign_in
end

post '/signup' do
  user = User.create({username: params[:username], password: params[:password], password_confirmation: params[:password_confirmation]})
  if user.persisted?
    session[:user] = user.id
  end
  redirect '/top'
end

post '/signin' do
  user = User.find_by(username: params[:username])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
    lists = Favorite.where(user_id: session[:user])
    lists.each do |list|
    favs = Contribution.where(id: list.contribution_id)
    favs.each do |fav|
      fav.favorite = true
      fav.save!
    end
  end
    redirect '/top'
  else
    redirect '/signin'
  end
end

get '/signout' do
  contributions = Contribution.all
  contributions.each do |contribution|
    contribution.favorite = false
    contribution.save!
  end
  session[:user] = nil
  redirect '/top'
end

get '/new' do
  erb :new
end

post '/new' do
  img_url = ''
  if params[:image]
    img = params[:image]
    tempfile = img[:tempfile]
    upload = Cloudinary::Uploader.upload(tempfile.path)
    img_url = upload['url']
  end
  contribution = Contribution.create({image: img_url, sweet_id: params[:sweet], ice_id: params[:ice], size_id: params[:size], plo_id: params[:plo], price_id: params[:price], store: params[:store], icename: params[:icename], station: params[:station], user_id: session[:user]})
  tags = params[:tag].split
    tags.each do |tag|
      tabletag = Tag.find_or_create_by({name: tag})
      ContributionTag.create({tag_id: tabletag.id, contribution_id: contribution.id})
    end
  redirect '/top'
end

get '/list' do
  @lists = Favorite.where(user_id: session[:user])
  erb :list
end

post '/:id/favorite' do
  if session[:user]
  this = Contribution.find(params[:id])
  this.favorite = !this.favorite
  this.save
  favuser = Favorite.find_by(user_id: session[:user], contribution_id: params[:id])
    if favuser
      favuser.delete
    else
      Favorite.create({user_id: session[:user], contribution_id: params[:id]})
    end
  else
    contributions = Contribution.all
    contributions.each do |contribution|
    contribution.favorite = false
    contribution.save!
  end
  end
 redirect '/top'
end

post '/list/:id/favorite' do
  if session[:user]
  this = Contribution.find(params[:id])
  this.favorite = !this.favorite
  this.save
  favuser = Favorite.find_by(user_id: session[:user], contribution_id: params[:id])
    if favuser
      favuser.delete
    else
      Favorite.create({user_id: session[:user], contribution_id: params[:id]})
    end
  else
    contributions = Contribution.all
    contributions.each do |contribution|
    contribution.favorite = false
    contribution.save!
  end
  end
 redirect '/list'
end

get '/search' do
  erb :search
end

post '/search' do
  if params[:search].try(:include?, "store")
    @results = Contribution.where(store: params[:store])
    if params[:search].try(:include?, "icename")
      @results = Contribution.where(store: params[:store], icename: params[:icename])
      if params[:search].try(:include?, "station")
        @results = Contribution.where(store: params[:store], icename: params[:icename], station: params[:station])
      end
    elsif params[:search].try(:include?, "station")
      @results = Contribution.where(store: params[:store], station: params[:station])
    end
  elsif params[:search].try(:include?, "icename")
    @results = Contribution.where(icename: params[:icename])
    if params[:search].try(:include?, "station")
      @results = Contribution.where(icename: params[:icename], station: params[:station])
    end
  elsif params[:search].try(:include?, "station")
    @results = Contribution.where(station: params[:station])


  elsif params[:search].try(:include?, "sweet")
    @results = Contribution.where(sweet_id: params[:sweet])
    if params[:search].try(:include?, "ice")
      @results = Contribution.where(sweet_id: params[:sweet], ice_id: params[:ice])
      if params[:search].try(:include?, "size")
        @results = Contribution.where(sweet_id: params[:sweet], ice_id: params[:ice], size_id: params[:size])
        if params[:search].try(:include?, "plo")
          @results = Contribution.where(sweet_id: params[:sweet], ice_id: params[:ice], size_id: params[:size],plo_id: params[:plo])
          if params[:search].try(:include?, "price")
            @results = Contribution.where(sweet_id: params[:sweet], ice_id: params[:ice], size_id: params[:size],plo_id: params[:plo], price_id: params[:price])
          end
        elsif params[:search].try(:include?, "price")
          @results = Contribution.where(sweet_id: params[:sweet], ice_id: params[:ice], size_id: params[:size],price_id: params[:price])
        end
      elsif params[:search].try(:include?, "plo")
        @results = Contribution.where(sweet_id: params[:sweet], ice_id: params[:ice], plo_id: params[:plo])
        if params[:search].try(:include?, "price")
          @results = Contribution.where(sweet_id: params[:sweet], ice_id: params[:ice], plo_id: params[:plo], price_id: params[:price])
        end
      elsif  params[:search].try(:include?, "price")
        @results = Contribution.where(sweet_id: params[:sweet], ice_id: params[:ice], price_id: params[:price])
      end
    elsif params[:search].try(:include?, "size")
      @results = Contribution.where(sweet_id: params[:sweet], size_id: params[:size])
      if params[:search].try(:include?, "plo")
        @results = Contribution.where(sweet_id: params[:sweet], size_id: params[:size],plo_id: params[:plo])
        if params[:search].try(:include?, "price")
          @results = Contribution.where(sweet_id: params[:sweet], size_id: params[:size],plo_id: params[:plo], price_id: params[:price])
        end
      elsif params[:search].try(:include?, "price")
        @results = Contribution.where(sweet_id: params[:sweet], size_id: params[:size],price_id: params[:price])
      end
    elsif params[:search].try(:include?, "plo")
      @results = Contribution.where(sweet_id: params[:sweet], plo_id: params[:plo])
      if params[:search].try(:include?, "price")
        @results = Contribution.where(sweet_id: params[:sweet], plo_id: params[:plo], price_id: params[:price])
      end
    elsif  params[:search].try(:include?, "price")
      @results = Contribution.where(sweet_id: params[:sweet], price_id: params[:price])
    end
  elsif params[:search].try(:include?, "ice")
    @results = Contribution.where(ice_id: params[:ice])
    if params[:search].try(:include?, "size")
      @results = Contribution.where(ice_id: params[:ice], size_id: params[:size])
      if params[:search].try(:include?, "plo")
        @results = Contribution.where(ice_id: params[:ice], size_id: params[:size],plo_id: params[:plo])
        if params[:search].try(:include?, "price")
          @results = Contribution.where(ice_id: params[:ice], size_id: params[:size],plo_id: params[:plo], price_id: params[:price])
        end
      elsif params[:search].try(:include?, "price")
        @results = Contribution.where(ice_id: params[:ice], size_id: params[:size],price_id: params[:price])
        end
    elsif params[:search].try(:include?, "plo")
      @results = Contribution.where(ice_id: params[:ice], plo_id: params[:plo])
      if params[:search].try(:include?, "price")
        @results = Contribution.where(ice_id: params[:ice], plo_id: params[:plo], price_id: params[:price])
      end
    elsif  params[:search].try(:include?, "price")
      @results = Contribution.where(ice_id: params[:ice], price_id: params[:price])
    end
  elsif params[:search].try(:include?, "size")
    @results = Contribution.where(size_id: params[:size])
    if params[:search].try(:include?, "plo")
      @results = Contribution.where(size_id: params[:size],plo_id: params[:plo])
      if params[:search].try(:include?, "price")
        @results = Contribution.where(size_id: params[:size],plo_id: params[:plo], price_id: params[:price])
      end
    elsif params[:search].try(:include?, "price")
      @results = Contribution.where(size_id: params[:size],price_id: params[:price])
    end
  elsif params[:search].try(:include?, "plo")
    @results = Contribution.where(plo_id: params[:plo])
      if params[:search].try(:include?, "price")
        @results = Contribution.where(plo_id: params[:plo], price_id: params[:price])
      end
  elsif  params[:search].try(:include?, "price")
    @results = Contribution.where(price_id: params[:price])


  elsif params[:search].try(:include?, "tag")
    tag = Tag.find_by(name: params[:tag])
    tagids = ContributionTag.where(tag_id:tag.id)
    tagids.each do |tagid|
      @results = Contribution.where(id:tagid.contribution_id)
    end


  else
    @results = Contribution.none
  end
  session[:result] = @results
  redirect '/result'
end

get '/result' do
  @results = session[:result]
  erb :result
end

post '/result/:id/favorite' do
  if session[:user]
  this = Contribution.find(params[:id])
  this.favorite = !this.favorite
  this.save
  favuser = Favorite.find_by(user_id: session[:user], contribution_id: params[:id])
    if favuser
      favuser.delete
    else
      Favorite.create({user_id: session[:user], contribution_id: params[:id]})
    end
  else
    contributions = Contribution.all
    contributions.each do |contribution|
    contribution.favorite = false
    contribution.save!
  end
  end
 redirect '/result'
end

post '/:id/delete' do
  this = Contribution.find(params[:id])
  this.delete
  redirect '/top'
end