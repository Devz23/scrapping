# spec/mairie_christmas.rb
require_relative '../lib/mairie_christmas'
require 'rspec'

RSpec.describe 'TownhallScraper' do
  describe '#get_townhall_urls' do
    it 'returns an array of URLs' do
      allow(self).to receive(:get_townhall_urls).and_return([
        'https://lannuaire.service-public.fr/townhall/1',
        'https://lannuaire.service-public.fr/townhall/2'
      ])

      urls = get_townhall_urls
      expect(urls).to be_an(Array)
      expect(urls).to include('https://lannuaire.service-public.fr/townhall/1')
      expect(urls).to include('https://lannuaire.service-public.fr/townhall/2')
    end
  end

  describe '#get_townhall_email' do
    it 'returns an array of email hashes' do
      mock_urls = ['https://lannuaire.service-public.fr/townhall/1']
      allow(self).to receive(:get_townhall_email).and_return([
        { "Townhall 1" => "townhall1@email.com" }
      ])

      emails = get_townhall_email(mock_urls)
      expect(emails).to be_an(Array)
      expect(emails.first).to be_a(Hash)
      expect(emails.first.keys.first).to eq("Townhall 1")
      expect(emails.first.values.first).to eq("townhall1@email.com")
    end
  end
end
