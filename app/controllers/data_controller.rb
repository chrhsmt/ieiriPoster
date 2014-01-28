require 'csv'
require 'json'
require 'open-uri'

class DataController < ApplicationController

  skip_before_filter :verify_authenticity_token ,:only=>[:download]
  # before_action :set_datum, only: [:show, :edit, :update, :destroy]

  def index
  	categoriesJson = JSON.parser.new(open(Settings.shirasete_api.issue_categories).read).parse
  	@categories = categoriesJson['issue_categories'].unshift({"name" => "全体", "id" => "all" })
  end

  def download
  	category = params[:category]
  	urlParam = ''
  	if category.present? && category != 'all'
  		urlParam = "&category_id=#{category}"
  	end

  	# call api
  	url = Settings.shirasete_api.open_issues + urlParam
  	logger.debug url
	json = JSON.parser.new(open(url).read)

  	# generate csv data
  	header = %w(エリア 住所 住所詳細)
  	csvData = CSV.generate(headers: header, write_headers: true, force_quotes: true) do | csv | 
		json.parse['issues'].each do | issue | 
			csv << [issue['category']['name'], issue['description'], issue['subject']] #, issue['geometry']["coordinates"]
		end  		
  	end
  	csvData.encode(Encoding::SJIS)

  	# csv to stream 
  	send_data csvData

  end

end
