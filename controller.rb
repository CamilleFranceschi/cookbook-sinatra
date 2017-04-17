require_relative "recipe"

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    # @view = View.new
  end

  def list
    # 1 je demande au controller la liste
    @cookbook.all #array of objects
    # je le montre au username
    # plsu rien ici
  end

  def create
    # demander à la vue le nom
    # name = params["name"]
    # # et la description
    # description = params["description"]
    # Create with .new
    attributes = {
      name: @name,
      description: @description
    }
    recipe = Recipe.new(attributes)
    # ajouter au cook book
    @cookbook.add_recipe(recipe)
  end
end
