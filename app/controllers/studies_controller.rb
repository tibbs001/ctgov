class StudiesController < ApplicationController
  before_action :set_study, only: [:show, :edit]

  def search
    if params[:search].present?
      @studies = Study.all
      #TODO  Get this working...  @studies = Study.search(params[:search])
    else
      @studies = Study.all
    end
  end

  # GET /studies
  # GET /studies.json
  def index
    #@studies=Study.sponsored_by('Duke')
    @studies=Study.all
    @definitions=DataDefinition.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study
			id=params[:id]
			id=params['format'] if !id
      @study = Study.find_by_nct_id(id)
    end

end

