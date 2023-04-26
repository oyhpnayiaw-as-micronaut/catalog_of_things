require_relative 'item'

class Game < Item
      attr_reader :multiplayer, :last_played_at
    
      def initialize(genre:, author:, label:, publish_date:, multiplayer:, last_played_at:)
        super(genre: genre, author: author, label: label, publish_date: publish_date)
        @multiplayer = multiplayer
        @last_played_at = last_played_at
      end
    
      def can_be_archived?
        super && @last_played_at > Date.today.prev_year(2) 
      end
    end
    
end
