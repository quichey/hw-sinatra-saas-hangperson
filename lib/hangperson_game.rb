class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @currentLetter = ''
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)
    @currentLetter = letter.downcase

    unless self.guessedAlready()
      @word.include?(letter) ? self.updateGuessList(@guesses) : self.updateGuessList(@wrong_guesses)
    else
      return false
    end
  end

  def updateGuessList(guessList)
    guessList << @currentLetter unless guessList.include? @currentLetter
  end

  def guessedAlready()
    return (@guesses.include? @currentLetter) || (@wrong_guesses.include? @currentLetter)
  end
end
