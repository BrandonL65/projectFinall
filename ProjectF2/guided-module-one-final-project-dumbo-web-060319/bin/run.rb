require_relative '../config/environment'
require 'pastel'
require 'artii'
$pastel = Pastel.new
$a = Artii::Base.new

#ProgressBar
def progressBar
    bar = TTY::ProgressBar.new("downloading [:bar]", total: 10)
    10.times do
      sleep(0.1)
      bar.advance(1)
    end
end
#Get a random Answer 
def sayHi
    puts $a.asciify("Quote  Me  2020")
    puts $pastel.magenta("Hello there, what is your name?")
    res = gets.chomp 
    progressBar
    puts $pastel.bright_green("Hello, #{res}, are you ready to play? (Y/N)")
    res2 = gets.chomp 
    progressBar
    arrOfAns = ["Aw why not, cmon try it! (Y/N)", "Who knows, maybe you'll love politics! Try! (Y/N)", "The first step to knowledge is to guess. (Y/N)", "Wall is Building. Press Y to stop. (Y/N)", "Why u so scared? Afraid you don't know your Donald? (Y/N)", "Okay, we'll give you some time to watch some FAKE NEWS(CNN). Press Y when you're done.","Why are you not China play? -Donald (Y/N)"]
    while (res2 != "Y")
        ran = arrOfAns.sample 
        puts $pastel.red(ran )
        res2 = gets.chomp
        progressBar
    end
end

def randomAnswerAndTwoRandoms
    x = Answer.all.sample(2)     #Two Random Answers 
end

def checkIfDuplicate(arr)
    mybool = 0 
    while mybool == 0
        if arr[0].candidate_id == arr[1].candidate_id
            arr = randomAnswerAndTwoRandoms
        else 
            mybool = 1
        end
    end
    return arr
end
def promptUser(arr)                                 #Selects a random 1 out of arr of size 2, puts it
    myQuote = arr.sample 
    myQuote = myQuote.quote_id
    myQuote = Quote.all.find_by(id: myQuote)
    puts $pastel.cyan(myQuote.content)
    makeFavorite(myQuote.content)
    progressBar
    return myQuote.content 
end

def promptUserForActualCandidate(arr1, str)
    myFinalArr=[]
    myFirstCand = arr1[0].candidate_id 
    myFirstCand = Candidate.find_by(id: myFirstCand)
    myFirstCand = myFirstCand.name 
    myFinalArr.push(myFirstCand)
    mySecondCand = arr1[1].candidate_id
    mySecondCand = Candidate.find_by(id: mySecondCand)
    mySecondCand = mySecondCand.name 
    myFinalArr.push(mySecondCand)

    correctPerson = ""
    arr1.each do |cand|
        x = cand.quote_id 
        person = cand.candidate_id
        person = Candidate.all.find_by(id: person)
        person = person.name 
        x = Quote.all.find_by(id: x)
        x = x.content 
        if x == str 
            correctPerson = person
        end
    end
    
    prompt = TTY::Prompt.new 
    prompt.select("SELECT THE CANDIDATE YOU THINK THE QUOTE IS FROM: ") do |choices|
        myFinalArr.each do |person|
            choices.choice "#{person}" => -> do 
                $selected = person 
            end
        end
    end
    progressBar
    if $selected == correctPerson
        puts $pastel.blue("CORRECT, NICE!")
    else 
        puts $pastel.red("Sorry, ya wrong!")
    end
    playAgain?
    
end

def playAgain?
    prompt = TTY::Prompt.new 
    ans = prompt.select("Do you want to play again or see favorites?" , %w(yes no favorites))
    if ans == "yes"
        ans = randomAnswerAndTwoRandoms
        myArr = checkIfDuplicate(ans)
        myStr = promptUser(myArr)
        promptUserForActualCandidate(myArr,myStr)
    elsif ans == "favorites"
        showFavorites
        playAgain?       
    end
end


def makeFavorite(str)
    prompt = TTY::Prompt.new 
    puts " "
    res = prompt.select("Do you want to make this a favorite quote?", %w(yes no))
    if res == "yes"
        progressBar
        baby = Favorite.new 
        baby.quote = str
        baby.save 
    end
end

def showFavorites 
    Favorite.all.each do |fav|
        if fav.quote != nil 
            puts " "
            puts $pastel.yellow(fav.quote)
            puts " "
            x = fav.quote 
            x = Quote.all.find_by(content: x)
            x = x.id 
            y = Answer.all.find_by(quote_id: x)
            y = y.candidate_id
            y = Candidate.all.find_by(id: y)
            puts "        BY: #{y.name}"
            puts " "
        end
    end
end 

def runfile
    sayHi
    ans = randomAnswerAndTwoRandoms
    myArr = checkIfDuplicate(ans)
    myStr = promptUser(myArr)
    promptUserForActualCandidate(myArr,myStr)

end


runfile 