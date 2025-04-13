MAX_GUESSES = 12
remaining_guesses = MAX_GUESSES
has_solved = false
is_player_guessing = true

def analyze_difference(secret, guess)
  correct_position_count = 0
  correct_number_count = 0
  secret_dict = {}
  guess_dict = {}

  guess.each_char.with_index do |char, index|
    secret_dict[secret[index]] = secret_dict[secret[index]] ? secret_dict[secret[index]] + 1 : 1
    guess_dict[char] = guess_dict[char] ? guess_dict[char] + 1 : 1

    if char == secret[index]
      correct_position_count += 1
    end
  end

  guess_dict.each_key do |key|
    if secret_dict[key]
      correct_number_count += [guess_dict[key], secret_dict[key]].min
    end
  end

  correct_number_count -= correct_position_count

  [correct_position_count, correct_number_count, guess.to_i > secret.to_i]
end

def prompt_valid_number()
  valid_input = false

  while !valid_input
    current_guess = gets.chomp

    if current_guess.length == 4 && current_guess.each_char.all? { |char| ('0'..'9').include?(char) }
      valid_input = true
    else
      puts "Please enter a 4 digit number"
    end
  end

  current_guess
end

def generate_guess(secret, guesses_left)
  new_guess = ""

  if guesses_left > 4 * MAX_GUESSES / 5
    new_guess = rand(0..9999).to_s.rjust(4, '0')
  elsif guesses_left > 3 * MAX_GUESSES / 5
    new_guess = rand(0..9).to_s + secret[1] + rand(0..99).to_s.rjust(2, '0')
  elsif guesses_left > 2 * MAX_GUESSES / 5
    new_guess = rand(0..9).to_s + secret[1] + rand(0..9).to_s + secret[3]
  else
    new_guess = secret[0..1] + rand(0..9).to_s + secret[3]
  end

  new_guess
end

puts "Let's play a game of Mastermind! I'll choose the secret number, is that okay?"
valid_answer = false

while !valid_answer
  puts "Answer with y or n (meaning yes or no)"
  player_decision = gets.chomp.downcase

  if player_decision == "y" || player_decision == "n"
    valid_answer = true
  end
end

if player_decision == "n"
  is_player_guessing = false
end

if is_player_guessing
  secret_number = rand(0..9999).to_s.rjust(4, '0')
  puts "Ok, I've decided on a 4 digit number. Can you guess what it is?"
else
  puts "Ok, you can choose the secret number then! What number do you want to use? I promise I'm not looking."
  secret_number = prompt_valid_number()
  puts "Great, it looks like that went through. Time for me to show you what I've got!" 
end

puts ""

while !has_solved && remaining_guesses > 0
  puts "Guess ##{MAX_GUESSES - remaining_guesses + 1} of #{MAX_GUESSES}:"

  if is_player_guessing
    current_guess = prompt_valid_number()
  else
    current_guess = generate_guess(secret_number, remaining_guesses)
    sleep(1.5)
    puts "I think your secret number is... #{current_guess}"
  end

  puts ""

  if current_guess == secret_number
    has_solved = true

    if is_player_guessing
      puts "That's right! My secret code was #{secret_number}. Congratulations! You win!"
    else
      puts "Aha, I was right! I just knew that your secret code was #{secret_number}!"
    end

    break
  else
    perfect_match_count, partial_match_count, is_too_high = analyze_difference(secret_number, current_guess)

    if is_player_guessing
      puts "Nope, that's not it! Your guess is too #{is_too_high ? "high" : "low"}"
    else
      puts "Hm, it seems my guess was too #{is_too_high ? "high" : "low"}"
    end

    puts "#{perfect_match_count} digits are perfect as is"
    puts "#{partial_match_count} digits are in the wrong place"
    puts ""
    remaining_guesses -= 1
  end
end

if !has_solved
  if is_player_guessing
    puts "I'm sorry, it's game over. You've run out of tries. My secret number was #{secret_number}"
  else
    puts "Oh no, I've run out of tries! I couldn't guess that your secret number was #{secret_number}"
  end  
end