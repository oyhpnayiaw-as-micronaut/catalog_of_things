require 'date'

require_relative 'item'

class Game < Item
  attr_accessor :multiplayer, :last_played_at

  def initialize(genre:, author:, label:, publish_date:, multiplayer:, last_played_at:)
    super(genre: genre, author: author, label: label, publish_date: publish_date)
    @multiplayer = multiplayer
    @last_played_at = begin
      Date.parse(last_played_at.to_s)
    rescue StandardError
      Date.today
    end
  end

  def can_be_archived?
    super && last_played_at < Date.today.prev_year(2)
  end
end
