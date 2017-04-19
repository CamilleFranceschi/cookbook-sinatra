require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "recipe"
require_relative "marmiton_service"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

# set :bind, '0.0.0.0'

# Page d'acceuil avec a liste des recettes

get '/' do
  @cookbook = Cookbook.new('data/cookbook.csv')
  @recipes = @cookbook.all
  erb :index
end



post '/new' do
  @recipe = Recipe.new(params)
  @cookbook = Cookbook.new('data/cookbook.csv')
  @cookbook.add_recipe(@recipe)
  redirect '/'
end

get '/new' do
  erb :new
end

post '/delete' do
  @cookbook = Cookbook.new('data/cookbook.csv')
  @cookbook.remove_recipe(params[:index].to_i)
  redirect '/'
end

get '/delete' do
  @cookbook = Cookbook.new('data/cookbook.csv')
  @recipes = @cookbook.all
  erb :delete
end

get '/import' do
  erb :import
end

post '/import' do
  @ingredient = params[:ingredient]
  marmiton_service = MarmitonService.new
  @results = marmiton_service.fetch_recipes(@ingredient)
  erb :results
end

# post '/add' do

#   index = params[:index].to_i
#   session[:ingredient] = params[:ingredient]
#   # marmiton_service = MarmitonService.new
#   # @results = marmiton_service.fetch_recipes(@ingredient)
#   @recipe = @results[index - 1]
#   @cookbook = Cookbook.new('data/cookbook.csv')
#   @cookbook.add_recipe(@recipe)
#   redirect '/'
# end

get '/add' do
  p params
  recipe = params["recipe"].select{|u| u != '"'}
  p recipe
  p recipe.name
  @cookbook = Cookbook.new('data/cookbook.csv')
  @cookbook.add_recipe(recipe)
  redirect '/'
end

get '/:index' do

  index = params[:index].to_i

  @cookbook = Cookbook.new('data/cookbook.csv')
  @recipes = @cookbook.all
  @recipe = @cookbook.find_recipe(index)
  erb :recipe
end

# get '/delete/recipe' do
#   @cookbook = Cookbook.new('data/cookbook.csv')
#   @cookbook.remove_recipe(params[:img_url])
#   redirect '/'
# end

  # get "/list" do
  #   csv_file_path = "data/cookbook.csv"
  #   @cookbook = Cookbook.new(csv_file_path)
  #   @controller = Controller.new(@cookbook)
  #   @recipes = @controller.list
  #   erb :list
  # end

  # get "/create" do
  #   csv_file_path = "data/cookbook.csv"
  #   @cookbook = Cookbook.new(csv_file_path)
  #   @controller = Controller.new(@cookbook)
  #   @name = params["name"]
  #   # et la description
  #   @description = params["description"]
  #   @controller.create
  #   @recipes = @controller.list
  #   erb :create
  # end

  # get '/team/:username' do
  #   puts params[:username]
  #   "The username is #{params[:username]}"
  # end


