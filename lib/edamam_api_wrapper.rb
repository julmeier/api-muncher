# require 'httparty'
# require 'awesome_print'
# require 'pry'
require_dependency '../../lib/recipe'

class EdamamApiWrapper

  BASE_URL = "https://api.edamam.com/search"
  ID = ENV["EDAMAM_ID"]
  KEY = ENV["EDAMAM_KEY"]

  def self.find_number_of_recipes(keywords)
    url =  BASE_URL + "?q=" + keywords + "&app_id=#{ID}&app_key=#{KEY}"
    # puts url
    results = HTTParty.get(url)
      number_of_recipes = results['count']
      # puts "NUMBER OF RECIPES: #{number_of_recipes}"
      return results['count']
  end

  def self.list_recipes(keywords, from, to)
    url = BASE_URL + "?q=" +  keywords + "&app_id=#{ID}&app_key=#{KEY}" + "&from=" + from.to_s + "&to=" + to.to_s
    # puts url
    results = HTTParty.get(url)
    recipes_list = []
    if results['hits']
      results['hits'].each do |recipe_data|
        # puts "HERE #{i} #{create_recipe(recipe_data)}"
        recipes_list << create_recipe(recipe_data)
      end
      return recipes_list
    else
      return []
    end
  end

  def self.show_recipe(uri_id)
    r = "http://www.edamam.com/ontologies/edamam.ow" + uri_id
    url = BASE_URL + "?r=" + r + "&app_id=#{ID}&app_key=#{KEY}"
    # puts url
    results = HTTParty.get(url)
    # puts results
    recipe = create_recipe_for_show(results)
    if recipe
      return recipe
    else
      return false
    end
  end

  private

  def self.create_recipe(api_params)
    recipe = Recipe.new({
        "label" => api_params["recipe"]["label"],
        "image" => api_params["recipe"]["image"],
        "source" => api_params["recipe"]["source"],
        "url" => api_params["recipe"]["url"],
        "dietLabels" => api_params["recipe"]["dietLabels"],
        "healthLabels" => api_params["recipe"]["healthLabels"],
        "ingredientLines" => api_params["recipe"]["ingredientLines"],
        "uri" => api_params["recipe"]["uri"]
      }
    )
    return recipe
  end

  def self.create_recipe_for_show(api_params)
    recipe = Recipe.new({
        "label" => api_params[0]["label"],
        "image" => api_params[0]["image"],
        "source" => api_params[0]["source"],
        "url" => api_params[0]["url"],
        "dietLabels" => api_params[0]["dietLabels"],
        "healthLabels" => api_params[0]["healthLabels"],
        "ingredientLines" => api_params[0]["ingredientLines"],
        "uri" => api_params[0]["uri"]
      }
    )
    return recipe
  end
end
