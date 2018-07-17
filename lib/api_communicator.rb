require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  character_hash = get_parse_json_from_character_api
  films_array = find_correct_character_films(character_hash, character)
  get_film_information(films_array)
end

def get_parse_json_from_character_api
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)
end

def find_correct_character_films(character_hash, character)
  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  films_array = []
  character_hash["results"].each do |char|
    if char["name"] == character
      films_array = char["films"]
    end
  end

  if films_array == []
    puts "This character is not found in any Star Wars films!"
  end

  films_array
end

def get_film_information(films_array)
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  films_hash = films_array.map! do |film_string|
    film_json = RestClient.get(film_string)
    film_hash = JSON.parse(film_json)
  end
end
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.

def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  films_hash.map do |film|
    film["title"]
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  puts "*" * 30
  puts parse_character_movies(films_hash)
end
## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
