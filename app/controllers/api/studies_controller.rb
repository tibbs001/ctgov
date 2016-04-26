module Api
  class StudiesController < ApplicationController

		def index
			serialize_options = {:dasherize => false}
			if params[:nct_id]
				cmd="Study.where('nct_id=?','#{params[:nct_id]}')"
			else
				cmd="Study"
			end
			if params[:include]
				if params[:include].include?(',')
					params[:include].split(",").each{|attrib|
						serialize_options.merge!(:include => attrib)
						cmd=cmd + ".includes(:#{attrib})"
					}
				else
					attrib=params[:include].to_sym
					serialize_options.merge!(:include => attrib)
					cmd=cmd + ".includes(:#{attrib})"
				end
			end
			if cmd=='Study'
				@studies = Study.all
			else
				@studies=eval(cmd)
			end
			if @studies.empty?
				render :text => nil, :status => 404 and return
			end
			respond_to do |format|
				format.xml {render :xml => @studies.to_xml(serialize_options)}
				format.json do
					render :json => "{\"all_studies\":[#{@studies.collect{|p| p.to_json(serialize_options)}.join(",")}]}"
				end
			end
		end

		def create
			render json: params.to_json
		end
	end
end

