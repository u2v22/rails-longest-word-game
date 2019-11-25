require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    grid_size = 7
    chars = ('A'..'Z').to_a
    @new_grid_array = (0...grid_size).map { chars.sample }
  end

  def score
    # Add guess words to has while counting instances in values
    guess_word = params[:score]
    guess_word_array = guess_word.chars
    guess_word_hash = Hash.new(0)
    guess_word_array.each { |letter| guess_word_hash[letter.downcase] += 1 }

    grid_chars_hash = Hash.new(0)
    new_grid_array = params[:letters].split
    new_grid_array.each { |letter| grid_chars_hash[letter.downcase] += 1 }

    # Api to check if word exists
    url = "https://wagon-dictionary.herokuapp.com/#{guess_word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)

    exists = params[:letters].chars.all? { |letter| grid_chars_hash[letter] >= guess_word_hash[letter] }

    if user['found'] && exists
      @score = 'Congrats, the word exists and is within the block'
    elsif user['found'] && exists
      @score = 'The word exists but is not one of the possible options'
    elsif !user['found'] && exists
      @score = 'The word exists in the grid but is not an actual word'
    else
      @score = 'The word is not a real word nor does it exist in the options'
    end
  end
end
