require 'csv'
require 'json'
require 'open-uri'

class DataController < ApplicationController

  skip_before_filter :verify_authenticity_token ,:only=>[:download]
  # before_action :set_datum, only: [:show, :edit, :update, :destroy]

  def index
  end

  def download

  	# call api
  	url = Settings.shirasete_api.open_issues
	json = JSON.parser.new(open(url).read)

  	# generate csv data
  	header = %w(エリア 地名 設置場所)
  	csvData = CSV.generate(headers: header, write_headers: true, force_quotes: true) do | csv | 
		json.parse['issues'].each do | issue | 
			csv << [issue['category']['name'], issue['subject'], issue['description']] #, issue['geometry']["coordinates"]
		end  		
  	end
  	csvData.encode(Encoding::SJIS)

  	# csv to stream 
  	send_data csvData

  end

end
