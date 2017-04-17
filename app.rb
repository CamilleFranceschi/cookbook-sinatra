require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "controller"
require_relative "recipe"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

# set :bind, '0.0.0.0'




  get '/' do
    erb :index
  end

  post '/' do
    case params["index"]
    when "1"
      redirect '/list'
    when "2"
      redirect '/create'
    when "3"
      redirect '/destroy'
    when "4"
      redirect '/import'
    end
  end

  get "/list" do
    csv_file_path = "data/cookbook.csv"
    @cookbook = Cookbook.new(csv_file_path)
    @controller = Controller.new(@cookbook)
    @recipes = @controller.list
    erb :list
  end

  get "/create" do
    csv_file_path = "data/cookbook.csv"
    @cookbook = Cookbook.new(csv_file_path)
    @controller = Controller.new(@cookbook)
    @name = params["name"]
    # et la description
    @description = params["description"]
    @controller.create
    @recipes = @controller.list
    erb :create
  end

  get '/team/:username' do
    puts params[:username]
    "The username is #{params[:username]}"
  end


