require 'csv'
require 'json'
require 'open-uri'


class DataController < ApplicationController

  skip_before_filter :verify_authenticity_token ,:only=>[:download]
  # before_action :set_datum, only: [:show, :edit, :update, :destroy]

  # GET /data
  # GET /data.json
  def index
  end

  def download
  	
  	# call api
  	key = "026f83f7a75f8b9add3bfdf623794bb69073cebc"
  	# url = "http://beta.shirasete.jp/projects/ieiri-poster/issues.json?status_id=open"
  	url = "http://beta.shirasete.jp/projects/ieiri-poster/issues.json?status_id=close&key=#{key}"
	json = JSON.parser.new(open(url).read)

  	# generate csv data
  	header = %w(subject category)
  	csvData = CSV.generate(headers: header, write_headers: true, force_quotes: true) do | csv | 
		json.parse['issues'].each do | issue | 
			csv << [issue['subject'], issue['category']['name']] #, issue['geometry']["coordinates"]
		end  		
  	end
  	csvData.encode(Encoding::SJIS)

  	# csv to stream 
  	send_data csvData

  end

  # # POST /data
  # # POST /data.json
  # def create
  #   @datum = Datum.new(datum_params)

  #   respond_to do |format|
  #     if @datum.save
  #       format.html { redirect_to @datum, notice: 'Datum was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @datum }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @datum.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

end
