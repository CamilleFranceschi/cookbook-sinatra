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

get '/import' do
  erb :import
end

post '/import' do
  @ingredient = params[:ingredient]
  marmiton_service = MarmitonService.new
  @results = marmiton_service.fetch_recipes(@ingredient)
  erb :results
end

get '/delete' do
  @cookbook = Cookbook.new('data/cookbook.csv')
  @recipes = @cookbook.all
  erb :delete
end

post '/delete' do
  index = params[:index].to_i
  @cookbook = Cookbook.new('data/cookbook.csv')
  @cookbook.remove_recipe(index)
  redirect '/'
end

get '/:index' do
  index = params[:index].to_i
  @cookbook = Cookbook.new('data/cookbook.csv')
  @recipes = @cookbook.all
  @recipe = @cookbook.find_recipe(index)
  erb :recipe
end




