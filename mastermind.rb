max_guesses = 12
remaining_guesses = max_guesses
has_solved = false
cpu_code = rand(0..9999).to_s.rjust(4, '0')

def analyzeDifference(secret, guess)
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

  return [correct_position_count, correct_number_count, guess.to_i > secret.to_i]
end

puts "Let's play a game! I'm thinking of a 4 digit number. Can you guess what it is?"
puts ""

while !has_solved && remaining_guesses > 0
  valid_input = false

  while !valid_input
    puts "Guess ##{max_guesses - remaining_guesses + 1} of #{max_guesses}:"
    user_guess = gets.chomp

    if user_guess.length == 4 && user_guess.each_char.all? { |char| ('0'..'9').include?(char) }
      valid_input = true
    else
      puts "Please enter a 4 digit number"
    end
  end

  if user_guess == cpu_code
    has_solved = true
    puts ""
    puts "That's right! My secret code was #{cpu_code}. Congratulations! You win!"
    break
  else
    perfect_match_count, partial_match_count, is_too_high = analyzeDifference(cpu_code, user_guess)
    puts "Nope, that's not it! Your guess is too #{is_too_high ? "high" : "low"}"
    puts "#{perfect_match_count} digits are perfect as is"
    puts "#{partial_match_count} digits are in the wrong place"
    puts ""
    remaining_guesses -= 1
  end
end

if !has_solved
  puts "I'm sorry, it's game over. You've run out of tries. My secret number was #{cpu_code}"
end