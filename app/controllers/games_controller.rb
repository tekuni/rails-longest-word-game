require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    letters = ('a'..'z').to_a
    10.times do
      @letters <<  letters.sample
    end
    @letters = @letters.sort
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @message = ""
    #call the api
    url = 'https://wagon-dictionary.herokuapp.com/' + @word
    result = JSON.parse(open(url).read)
    is_english = result["found"]
    is_included = true

    if is_english == false
      @message = "Sorry but #{@word} does not seem to be a valid English word."
      return false
    end

    #check if its a word
    word_tmp = @word.split('')
    word_tmp.each do |letter|
      is_included = false if digit_in_array_count(word_tmp, letter) > digit_in_array_count(@letters.split(''), letter)
    end

    if is_english == true && is_included == true
      @message = "Congratulations! #{@word} is a valid English word!"
    elsif is_english == true && is_included == false
      @message = "Sorry but #{@word} cannot be built out of #{@letters}."
    end

  end

  def digit_in_number_count(n, digit)
    n.to_s.count(digit.to_s)
  end

  def digit_in_array_count(a, digit)
    a.reduce(0) { |t, n| t + digit_in_number_count(n, digit) }
  end

end
