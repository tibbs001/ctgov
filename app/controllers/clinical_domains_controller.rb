class ClinicalDomainsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :check_user, only: [:edit, :update, :destroy]

  # GET /reviews/new
  def new
    @domain = ClinicalDomain.new
		@study=Study.find_by_nct_id(params['nct_id'])
		@domain.study=@study
  end

  # GET /reviews/index
  def index
		@study=Study.find_by_nct_id(params['nct_id'])
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @domain = Review.new(domain_params)
    @domain.user_id = current_user.id
    @domain.nct_id = params['nct_id']
    @domain.clinical_category_id = params['clinical_category_id']
		@study=Study.find_by_nct_id(params['nct_id'])
		@domain.study=@study

    respond_to do |format|
      if @domain.save
        format.html { redirect_to controller: 'studies', action: 'edit', nct_id: @domain.nct_id }
        format.json { render :show, status: :created, location: @domain }
      else
        format.html { render :new }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @domain.update(review_params)
        format.html { redirect_to :action => 'index', notice: 'Review was successfully updated.', nct_id: @domain.nct_id }
        format.json { render :show, status: :ok, location: @domain }
      else
        format.html { render :edit }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @domain.destroy
    respond_to do |format|
      format.html { redirect_to :action => 'index', notice: 'Review was successfully removed.', nct_id: @domain.nct_id }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @domain = ClinicalDomain.find(params[:id])
      @study = Study.find(@domain.nct_id)
    end

    def check_user
      unless (@domain.user == current_user) || (current_user.admin?)
        redirect_to root_url, alert: "Sorry, this review belongs to someone else"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def domain_params
      params.require(:domain_name).permit(:comment)
    end
end
