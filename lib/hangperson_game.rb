class HangpersonGame

      # add the necessary class methods, attributes, etc. here
      # to make the tests in spec/hangperson_game_spec.rb pass.

      # Get a word from remote "random word" service

    #def initialize()
    #    @word = self.get_random_word
    #    finishinit()
    #end
  
    def initialize(word)
        @word = word
        finishinit()
    end
    
    def finishinit()
        @guesses = ''
        @wrong_guesses = ''
        @word = @word.to_s.strip.empty? ? " " : @word
        @word.downcase!

        @word.split('').each do |a|
            @word_with_guesses = (@word_with_guesses.to_s.strip.empty? ?  "" : @word_with_guesses ) + '-'
        end
    
    end
    
    def word
        @word
    end
  
    def guesses
        @guesses
    end
    
    def wrong_guesses
        @wrong_guesses
    end
    
    def word_with_guesses
        @word_with_guesses
    end
  
      #init done
    
      # starting functions
    def guess(input)
        unless input.to_s.strip.empty? 
            if input.match(/[[:alpha:]]/)
                input.downcase!

                if (@guesses.to_s.strip.empty? ? true : !@guesses.include?(input) ) && (@wrong_guesses.to_s.strip.empty? ? true : !@wrong_guesses.include?(input))
                    setStringGuess(input)
                    return true
                end
                return false
            end
        end
        raise ArgumentError.new("Guess has to be an alphabet")
    end
    
    def setStringGuess(input)
        if @word.include?(input)
            @guesses = (@guesses.to_s.strip.empty? ?  "" : @guesses )+ input
            i = -1
            while i = @word.index(input,i+1)
                @word_with_guesses[i] = input
            end
        else
            @wrong_guesses = (@wrong_guesses.to_s.strip.empty? ?  "" : @wrong_guesses ) + input
        end
    end
    
    def check_win_or_lose()
        if @word_with_guesses.include?('-')
            if(@wrong_guesses.length >= 7)
                return :lose
            else
                return :play
            end
        end
        return :win
    end
  
      # You can test it by running $ bundle exec irb -I. -r app.rb
      # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
      #  => "cooking"   <-- some random word
    def self.get_random_word
        require 'uri'
        require 'net/http'
        uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
        #uri = URI('https://random-word-api.herokuapp.com/word')
        #response = Net::HTTP.get_response(uri)
        #print(response.body)
        #print(response.body.delete('[]\"'))
        #return response.body.delete('[]\"')
        Net::HTTP.new('watchout4snakes.com').start { |http|
          return http.post(uri, "").body
        }
    end

end
