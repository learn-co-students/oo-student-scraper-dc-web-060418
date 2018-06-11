require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_html = Nokogiri::HTML(open(index_url))
    student_profiles = index_html.css(".roster-cards-container")
    student_arr = []

    student_profiles.children.css(".student-card").each do |student|
      
      student_arr << {
        name: student.css(".student-name").text,
        location: student.css(".student-location").text,
        profile_url: student.css('a').attr("href").value

      }

    end 
    student_arr

  end

  def self.scrape_profile_page(profile_url)
    profile_html = Nokogiri::HTML(open(profile_url))
    student_hash = {}
    social = profile_html.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    social.each do |link|
      if link.include?("linkedin")
        student_hash[:linkedin] = link
      elsif link.include?("github")
        student_hash[:github] = link
      elsif link.include?("twitter")
        student_hash[:twitter] = link
      else
        student_hash[:blog] = link
      end
    end
    student_hash[:profile_quote] = profile_html.css(".profile-quote").text if profile_html.css(".profile-quote")
    student_hash[:bio] = profile_html.css("div.bio-content.content-holder div.description-holder p").text if profile_html.css("div.bio-content.content-holder div.description-holder p")

    student_hash
  end

end

