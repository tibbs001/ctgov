class StudiesController < ApplicationController
  before_action :set_study, only: [:show, :edit]

  def search
    if params[:search].present?
      @studies = Study.search(params[:search])
    else
      @studies = Study.all
    end
  end

  # GET /studies
  # GET /studies.json
  def index
    #sample_ids.each {|x| @studies << Study.find_by_nct_id(x)}
    #@studies
    #@studies=Study.completed_since(Date.today-100.days)
    @studies=Study.sponsored_by('Duke')
    @studies=Study.all
    @definitions=DataDefinition.all
    #@studies=[Study.find_by_nct_id('NCT01132846')]
    #@studies=Study.all
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
    @reviews = Review.where(nct_id: @study.nct_id).order("created_at DESC")
    if @reviews.blank?
      @avg_rating = 0
    else
      @avg_rating = @reviews.average(:rating).round(2)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_study
			id=params[:id]
			id=params['format'] if !id
      @study = Study.find_by_nct_id(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def study_params
      params[:study]
    end
end

