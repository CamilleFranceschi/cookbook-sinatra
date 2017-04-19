# require_relative "recipe"
# require_relative "view"
# require_relative "marmiton_service"

# class RecipesController
#   def initialize(cookbook)
#     @cookbook = cookbook
#     @view = View.new
#   end

#   # def list
#   #   # 1 je demande au controller la liste
#   #   @cookbook.all #array of objects
#   #   # je le montre au username
#   #   @view.display_all_recipes(recipes)
#   # end

#   def create
#     # demander à la vue le nom et la description
#     name = @view.ask_for_name_recipe
#     description = @view.ask_for_description_recipe
#     # Create with .new
#     attributes = {
#       name: @name,
#       description: @description
#     }
#     recipe = Recipe.new(attributes)
#     # ajouter au cook book
#     @cookbook.add_recipe(recipe)
#   end

#   def destroy
#     # demander à la vue l'index à delete
#     index = @view.ask_for_id
#     # le delete
#     @cookbook.remove_recipe(index)
#   end

#   def import
#     # Demander à la vue le mot cle
#     ingredient = @view.ask_for_ingredient
#     # telecharger et stocker(pas besoin en fait) les recettes
#     # 2. Scrape Letscookfrench for that keyword
#     scraper = MarmitonService.new
#     results = scraper.fetch_recipess(ingredient)
#     # Afficher toutes les recettes liees au mot cle
#     @view.display_all_recipes(results)
#     # Demander à la vue l'index de la recette a importer
#     index = @view.ask_for_id
#     # trouver la recette
#     recipe = results[index - 1]
#     # ajouter la recette au cookbook
#     @cookbook.add_recipe(recipe)
#   end
# end
