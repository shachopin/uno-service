require 'pry'
require 'sinatra'
require 'json'
require "./uno_game"

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret_random_string' 

uno = UnoGame.new
#1) sinatra session is still active even after you restart your server (for ruby or shotgun same way)
#2) shotgun restart your server per every request. That's why if you have object instantiation in your code, the obj will be reinstantiated. 
#To avoid that, we need to use standard ruby starter (port 4567)


before do
   content_type :json    
   headers 'Access-Control-Allow-Origin' => '*', 
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
end


get '/cards' do   # test by appending ?name=Dawei in url
  return_message = {} 
  if params.has_key?('name') 
    cards = uno.get_cards(params['name']) 
    if cards.class == Array 
      return_message[:status] = 'success' 
      return_message[:cards] = cards 
    else 
      return_message[:status] = 'sorry - it appears you are not part of the game' 
      return_message[:cards] = [] 
    end 
  end 
  return_message.to_json 
end 

# for :data to be a key in the params hash, you can do
# option 1, query params in the URL
# option 2, in the request body, but go thorugh form data (header has Content-type: application/x-www-form-urlencoded)
# key type name
# value type {"name" : "Dawei"}  - has to be the json string fomat, because allowing JSON.parse to work. Cannot do single quotes around key name
# option 3, use RestClient  and pass the :data like this:
# RestClient.post 'http://localhost:4567/join', :data => {name: @name}.to_json, :accept => :json 

# to parse the json from request body
# data = JSON.parse( request.body.read )

post '/join' do 
  return_message = {} 
  #jdata = JSON.parse(params[:data],:symbolize_names => true)  #params hash :data key will have a json string text
  jdata = JSON.parse(request.body.read, :symbolize_names => true)
  # now in the request body I can just pass {"name": "Dawei"} 
  if jdata.has_key?(:name) && uno.join_game(jdata[:name]) # converted that json string to ruby hash with symbolized name
    return_message[:status] = 'welcome' 
  else 
    return_message[:status] = 'sorry - game not accepting new players' 
  end 
  return_message.to_json 
end 

post '/deal' do   # post url /deal, no other
  return_message = {} 
  if uno.deal 
    return_message[:status] = 'success' 
  else 
    return_message[:status] = 'fail' 
  end 
  return_message.to_json 
end

post '/clear' do
  uno.clear_all_players
  {status: "success"}.to_json
end

get '/list' do
  return_message = {}
  return_message[:status] = 'success'
  return_message[:players] = uno.list_players
  return_message.to_json
end

