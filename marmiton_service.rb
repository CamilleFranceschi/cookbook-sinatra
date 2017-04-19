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
    attributes = {
      name: recipe_name,
      description: recipe_description
    }
    Recipe.new(attributes)
  end
end
