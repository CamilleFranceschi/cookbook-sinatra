require "csv"
require_relative "recipe"
require_relative "marmiton_service"
require "pry-byebug"

class Cookbook # OK
  attr_reader :recipes
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_from_csv
  end

  def all #OK
    @recipes # array of arrays
  end

  def find_recipe(index)
    @recipes[index - 1]
  end

  def add_recipe(recipe) #recipe est un objet # OKK
    # Rajouter dans ma variable d'instance le nouvelle objet
    @recipes << recipe
    # Rajouter dans le fichier csv mon nouvel objet recipe
    csv_options = { col_sep:',', force_quotes:true, quote_char: '"'}
    CSV.open(@csv_file_path, "a",csv_options) do |csv|
      csv << [recipe.name, recipe.description]
    end
  end

  def remove_recipe(index)
    # deleter l'objet de la variable d'instance recipes
    @recipes.delete_at(index)
    # deleter la ligne du fichier CSV == reloader le CSV en mode wb
    csv_options = { col_sep:',', force_quotes:true, quote_char: '"'}
    CSV.open(@csv_file_path, "wb", csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description]
      end
    end
  end

  private

  def load_from_csv
    return unless File.exist?(@csv_file_path)
    CSV.foreach(@csv_file_path) do |row|
      attributes = {
        name: row[0].to_s,
        description: row[1].to_s
      }
      @recipes << Recipe.new(attributes)
    end
  end
end

# cookbook = Cookbook.new('data/cookbook.csv')
# p cookbook.remove_recipe(1)
# p
