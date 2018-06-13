require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    students = Nokogiri::HTML(html)
    students_array = []

    students.css(".student-card").each do |student|
      new_hash = {
        :name => student.css("h4").text,
        :location => student.css("p").text,
        :profile_url => student.css("a").attribute("href").value
      }
      students_array << new_hash
    end
    #binding.pry
    students_array
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)
    profile_hash = {}
    #iterate through all links, find out if their url contains social media names and add them as key-value pairs
    profile.css("a").each do |link|
      case
      when link['href'].include?("twitter")
        profile_hash[:twitter] = link['href']
      when link['href'].include?("linkedin")
        profile_hash[:linkedin] = link['href']
      when link['href'].include?("github")
        profile_hash[:github] = link['href']
      when link['href'].end_with?(".com/")
        profile_hash[:blog] = link['href']
      end
    end
    profile_hash[:profile_quote] = profile.css(".profile-quote").text
    profile_hash[:bio] = profile.css(".bio-content p").text
    profile_hash
  end

end

