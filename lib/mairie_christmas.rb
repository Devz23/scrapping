require 'pry'
require 'nokogiri'
require 'open-uri'
require 'uri'

def get_townhall_urls
  townhall_urls = []
  base_url = "https://lannuaire.service-public.fr/navigation/ile-de-france/val-d-oise/mairie"
  page_number = 0

  10.times do |i|
    page_number += 1
    current_url = "#{base_url}?page=#{page_number}"

    page = Nokogiri::HTML(URI.open(current_url))
    links = page.xpath('//a[@class="fr-link"]')

    links.each do |link|
      relative_url = link['href']
      if relative_url.start_with?("http")
        townhall_urls << relative_url
      else
        townhall_urls << "https://lannuaire.service-public.fr#{relative_url}"
      end
    end
  end

  return townhall_urls
end

def get_townhall_email(townhall_urls)
  results = []

  townhall_urls.each do |url|
    begin
      page = Nokogiri::HTML(URI.open(url))
      townhall_name = page.xpath('//h1[@id="titlePage"]').text.strip
      townhall_email = page.xpath('//a[contains(@class, "send-mail")]').text.strip

      results << { townhall_name.sub('Mairie - ', '') => townhall_email } unless townhall_email.empty?

    rescue StandardError => e
      puts "Error accessing the URL #{url}: #{e.message}"
    end
  end

  return results
end

townhall_urls = get_townhall_urls
townhall_emails = get_townhall_email(townhall_urls)

townhall_emails.each do |entry|
  entry.each do |townhall, email|
    puts "#{townhall} => #{email}"
  end
end
