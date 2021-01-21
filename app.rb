require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new' 
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!
     print("test create"+"\n")
    @game = HangpersonGame.new(word)
     print(@game.word_with_guesses+" test 2 "+@game.wrong_guesses+"\n")
     print(@game.check_win_or_lose.to_s+" test 3 \n") 
     session[:game] = @game
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    ### YOUR CODE HERE ###
    begin
        @valid = @game.guess(letter)
    rescue ArgumentError
      flash[:message] = "Invalid guess."
    else
        unless @valid
            flash[:message] = "You have already used that letter."
        end
    end
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
    print(@game.word_with_guesses+" test 6 "+@game.wrong_guesses+"\n")
    result = @game.check_win_or_lose
      
      
    print(@game.word_with_guesses+" test 6 "+@game.wrong_guesses+"\n")
    print(result.to_s+" test 5 \n")
      
    case result
        when :win
            redirect '/win'
        when :lose
            redirect '/lose'
    end
    erb :show # You may change/remove this line
  end
  
  get '/win' do
    ### YOUR CODE HERE ###
    if @game.word.to_s.strip.empty?
         redirect '/new' 
    end
    result = @game.check_win_or_lose
    case result
        when :play
            redirect '/show'
        when :lose
            redirect '/lose'
    end
    erb :win # You may change/remove this line
  end
  
  get '/lose' do
    ### YOUR CODE HERE ###
    if @game.word.to_s.strip.empty?
         redirect '/new' 
    end
    result = @game.check_win_or_lose
    case result
        when :play
            redirect '/show'
        when :win
            redirect '/win'
    end
    erb :lose # You may change/remove this line
  end
  
end
