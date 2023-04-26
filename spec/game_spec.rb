require 'date'

require_relative '../lib/models/item'
require_relative '../lib/models/game'

describe Game do
  let(:game) do
    Game.new(genre: nil, author: nil, label: nil, publish_date: Date.today, multiplayer: true,
             last_played_at: Date.today)
  end

  describe '#initialize' do
    it 'creates a new instance of Game' do
      expect(game).to be_an_instance_of Game
    end
  end

  describe '#can_be_archived?' do
    it 'returns false if publish_date is less than 10 year' do
      expect(game.can_be_archived?).to be false
    end

    it 'returns true if the last played time is more than 2 years and publish_date is less than 10 year' do
      game.publish_date = Date.today.prev_year(11)
      game.last_played_at = Date.today.prev_year(3)
      expect(game.can_be_archived?).to be true
    end
  end
end
