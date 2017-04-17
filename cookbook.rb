require "csv"
require_relative "recipe"


class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    # @recipes = CSV.read(@csv_file_path) # @recipes = array of arrays pas un array d'objets !!!!!!
    # ajouter dans la variale d'instance recipes toutes les OBJETS recipe à construire à partir du fichier csv
    #load CSV
    @recipes = []
    return unless File.exist?(@csv_file_path)
    CSV.foreach(@csv_file_path) do |row|
      attributes = {
        name: row[0].to_s,
        description: row[1].to_s
      }
      @recipes << Recipe.new(attributes)
    end
  end

  def all
    @recipes # array of arrays
  end

  def add_recipe(recipe) #recipe est un objet
    # Rajouter dans ma variable d'instance le nouvelle objet
    @recipes << recipe
    # Rajouter dans le fichier csv mon nouvel objet recipe
    csv_options = { col_sep:',', force_quotes:true, quote_char: '"'}
    CSV.open(@csv_file_path, "a", csv_options) do |csv|
      csv << ["#{recipe.name}", "#{recipe.description}"]
    end
  end

  def remove_recipe(index)
    # deleter l'objet de la variable d'instance recipes
    @recipes.delete_at(index - 1)
    # deleter la ligne du fichier CSV == reloader le CSV en mode wb
    csv_options = { col_sep:',', force_quotes:true, quote_char: '"'}
    CSV.open(@csv_file_path, "wb", csv_options) do |csv|
      @recipes.each do |recipe|
        csv << ["#{recipe.name}", "#{recipe.description}"]
      end
    end
  end
end

