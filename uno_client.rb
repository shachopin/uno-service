require 'json' 
require 'rest-client' 

class UnoClient 
  attr_reader :name 

  def initialize name 
    @name = name 
  end 

  def join_game 
    #response = RestClient.post 'http://localhost:4567/join', :data => {name: @name}.to_json, :accept => :json 
    response = RestClient.post "http://localhost:4567/join", {name: @name}.to_json, {content_type: :json}
    puts JSON.parse(response,:symbolize_names => true) 
  end 

  def get_cards 
    response = RestClient.get 'http://localhost:4567/cards', {:params => {:name => @name}} 
    puts response 
    #puts JSON.parse(response,:symbolize_names => true)
  end 

  def deal 
    response = RestClient.post 'http://localhost:4567/deal', :accept => :json 
    puts response 
  end 

end

# client side testing logic

bob_uno = UnoClient.new 'bob'
carol_uno = UnoClient.new 'carol'
ted_uno = UnoClient.new 'ted'
alice_uno = UnoClient.new 'alice'
ralph_uno = UnoClient.new 'ralph'

bob_uno.join_game
carol_uno.join_game
ted_uno.join_game
alice_uno.join_game
ralph_uno.join_game

bob_uno.deal
bob_uno.get_cards
carol_uno.get_cards
ted_uno.get_cards
alice_uno.get_cards