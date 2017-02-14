class UnoGame
  attr_reader :deck, :pool, :hands, :number_of_hands 
  MAX_HANDS = 4 
  def initialize 
    @hands = Array.new # or []
    @number_of_hands = 0 
    @pool = Array.new 
    @deck = %w(2-diamond 3-diamond 4-diamond 5-diamond 6-diamond 7-diamond 8-diamond 9-diamond 10-diamond) 
    @deck.concat %w(2-heart 3-heart 4-heart 5-heart 6-heart 7-heart 8-heart 9-heart 10-heart) 
    @deck.concat %w(2-club 3-club 4-club 5-club 6-club 7-club 8-club 9-club 10-club) 
    @deck.concat %w(2-spade 3-spade 4-spade 5-spade 6-spade 7-spade 8-spade 9-spade 10-spade) 
    @deck.concat %w(jack-diamond jack-heart jack-club jack-spade) 
    @deck.concat %w(queen-diamond queen-heart queen-club queen-spade) 
    @deck.concat %w(king-diamond king-heart king-club king-spade) 
    @deck.concat %w(ace-diamond ace-heart ace-club ace-spade) 
    @deck.concat %w(joker-black joker-red) 
  end 

  def join_game player_name 
    return false unless @hands.size < MAX_HANDS 
    player = { 
        name: player_name, 
        cards: [] 
    } 
    @hands.push player 
    true 
  end 

  def deal 
    return false unless @hands.size > 0 
    @pool = @deck.shuffle 
    @hands.each {|player| player[:cards] = @pool.pop(5)} 
    true 
  end 

  def get_cards player_name 
    cards = 0
    @hands.each do |player| 
      if player[:name] == player_name 
        cards = player[:cards].dup 
        break 
      end 
    end 
    cards 
  end 

  def clear_all_players
    @hands.clear
  end

  def list_players
    players = []
    @hands.each do |player|
      players << player[:name]
    end
    players
  end

end
