require 'csv'
require 'json'
require 'open-uri'

class DataController < ApplicationController

  skip_before_filter :verify_authenticity_token ,:only=>[:download]
  # before_action :set_datum, only: [:show, :edit, :update, :destroy]

  LIMIT=100

  def index
  	@categories = getCategories
  end

  def download
  	category = params[:category]
  	urlParam = ''
  	if category.present? && category != 'all'
  		urlParam = "&category_id=#{category}"
  	end

	totalCount = getTotalCount(urlParam)
	loopCount = (totalCount.to_f / LIMIT).ceil
	logger.debug "totalCount : #{totalCount}, loopCount : #{loopCount}, limit: #{LIMIT}"

  	# generate csv data
  	header = %w(エリア 自治体名-投票区-掲示板番号 住所)
  	csvData = CSV.generate(headers: header, write_headers: true, force_quotes: true) do | csv | 

		(0..(loopCount - 1)).each do | count |

		  	# call api
		  	url = Settings.shirasete_api.open_issues + urlParam + "&limit=#{LIMIT}&offset=#{count * LIMIT}&sort=category,id"
		  	logger.debug url
			json = JSON.parser.new(open(url).read)

			json.parse['issues'].each do | issue | 
				area = issue['category'].nil? ? '' : issue['category']['name'].gsub(/\r\n|\r|\n/, " ")
				description = issue['description'].gsub(/\r\n|\r|\n/, " ")
				subject = issue['subject'].gsub(/\r\n|\r|\n/, " ")
				csv << [area, subject, description] #, issue['geometry']["coordinates"]
			end  		

	  end
  	end
  	csvData.encode(Encoding::SJIS)

  	filename = getCategoryName(category) + "_" + Time.now.strftime('%Y%m%d%H%M%S') + ".csv" 
  	# csv to stream 
  	send_data csvData, filename: filename

  end

  private 

  def getTotalCount(urlParam = nil)

  	url = Settings.shirasete_api.open_issues + urlParam + "&limit=1"
	json = JSON.parser.new(open(url).read)
	totalCount = json.parse['total_count'].to_i

  end

  def getCategories
  	categoriesJson = JSON.parser.new(open(Settings.shirasete_api.issue_categories).read).parse
  	categoriesJson['issue_categories'].unshift({"name" => "全体", "id" => "all" })
  end

  def getCategoryName(id)
  	logger.debug "id : #{id}, #{id.class}"
  	getCategories.select {|m| m["id"].to_s == id}.first["name"]

  end

end
