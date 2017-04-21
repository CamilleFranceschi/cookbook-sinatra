# encoding: UTF-8
require 'nokogiri'
require 'open-uri'
require_relative "recipe"
require "pry-byebug"

class MarmitonService

  def fetch_recipes(ingredient)
    count = 0
    results = []
    begin
      doc = marmiton_doc(ingredient, count)
      doc.xpath("//div[@class='m_titre_resultat']/a").each do |element|
        results << parse_recipe(element)
      end
      count += 10
    end until count == 10
    return results
  end

  private

  def marmiton_doc(ingredient, count) # methode qui renvoit Nokogiri::HTML::Document
    url1 = "http://www.marmiton.org/recettes/recherche.aspx?aqt=#{ingredient}&start=#{count}"
    html_doc_1 = Nokogiri::HTML(open(url1).read)
    html_doc_1.encoding = 'utf-8'
    html_doc_1
  end

  def parse_recipe(html_element)
    recipe_name = html_element.text # string = nom de la recette
    partial_url = html_element.attribute("href").value # string url partielle
    url2 = "http://www.marmiton.org#{partial_url}"
    html_doc_2 = Nokogiri::HTML(open(url2).read)
    html_doc_2.encoding = 'utf-8'
    recipe_description = html_doc_2.search(".m_content_recette_todo").text
    # .gsub!(/Remarques.*/,"").gsub!(/'/,"\'")
    attributes = {
      name: recipe_name,
      description: recipe_description
    }
    Recipe.new(attributes)
  end
end

# test = "\r\n                    \r\n                    Préparation de la recette :\r\n                    \r\n                    Beurrer légèrement un moule à charlotte et disposer dans le fond un rond de papier sulfurisé. Verser 10 cl d'eau et le rhum dans le fond d'une assiette creuse. Tremper rapidement les biscuits et tapisser entièrement le fond et les bords du moule (côté bombé vers l'extérieur). Séparer les jaunes d'oeufs des blancs. Mettre à fondre le chocolat avec le lait dans un saladier à bain-marie doux. Le laisser fondre entièrement et le lisser avec une spatule en bois. En maintenant la préparation au bain-marie ajouter peu à peu le beurre en petits morceaux tout en remuant, puis les jaunes d'oeuf l'un après l'autre. Travailler la crème quelques instants jusqu'à ce qu'elle soit bien lisse et brillante puis retirer la casserole du feu et laisser refroidir. Monter les blancs d'oeuf en neige en ajoutant à la fin le sucre glace en pluie. Battre la crème liquide (très froide) en chantilly un peu molle. Incorporer les deux préparations à la crème afin d'obtenir un mélange lisse et parfaitement homogène. Remplir le moule avec la mousse au chocolat en la tassant légèrement, terminer par une couche de biscuits imbibés. Couvrir d'une assiette, un poids dessus et mettre au frigo jusqu'au lendemain. Pour servir retourner le moule sur le plat de service, retirer le fond de papier sulfurisé. Décorer de copeaux de chocolat ou la saupoudrer simplement d'un peu de cacao.\r\n                    \r\n                        \r\n                        Remarques :\r\n                        On peut l'accompagner d'une crème anglaise fortement vanillée.\r\nA la place du mélange rhum/eau on peut tremper les biscuits dans du sirop de sucre.\r\n\r\n                        \r\n                    \r\n                "
# p test
# MarmitonService.new.fetch_recipes("chocolat")
