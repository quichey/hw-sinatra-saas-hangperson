class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_reader :word
  attr_reader :guesses
  attr_reader :wrong_guesses
  attr_reader :word_with_guesses

  def initialize(word)
    @word = word
    @wordNormalized = word.downcase
    @guesses = ''
    @wrong_guesses = ''
    @currentLetter = ''
    @word_with_guesses = ''
    word.each_char {|letter| @word_with_guesses << '-'}
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
    @currentLetter = letter

    self.validateGuess()

    @currentLetter = letter.downcase

    unless self.guessedAlready() || (self.check_win_or_lose() != :play)
      if @wordNormalized.include? @currentLetter
        self.updateGuessList(@guesses)
        self.updateWordDisplay()
      else
        self.updateGuessList(@wrong_guesses)
      end
    else
      return false
    end

  end

  def updateGuessList(guessList)
    guessList << @currentLetter unless guessList.include? @currentLetter
  end

  def updateWordDisplay()
    for i in 0..@word.length
      if @wordNormalized[i] == @currentLetter
        @word_with_guesses[i] = @word[i]
      end
    end
  end

  def guessedAlready()
    return (@guesses.include? @currentLetter) || (@wrong_guesses.include? @currentLetter)
  end

  def validateGuess()
    case @currentLetter
    when ''
      raise ArgumentError.new('Must guess something!')
    when nil
      raise ArgumentError.new('Guess is nil value!')
    end

    unless @currentLetter =~ /[[:alpha:]]/
      raise ArgumentError.new('Must guess a letter!')
    end
  end

  def check_win_or_lose()
    if @word_with_guesses == @word
      return :win
    elsif @wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
  end
end
