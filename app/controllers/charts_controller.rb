class ChartsController < ApplicationController
  before_action :set_chart, only: [:show, :edit, :update, :destroy]

  # GET /charts
  # GET /charts.json
  def index
    gon.since_date=(Date.today - 2.years).to_s
    study_types=Study.completed_since(gon.since_date).collect{|s|s.study_type}.flatten
    study_phases=Study.completed_since(gon.since_date).collect{|s|s.phase}.flatten
    count_hash = Hash.new(0)
    study_types.each{|x|count_hash[x] += 1 if x}
    gon.type_counts=@type_count=count_hash.collect{|k,v| [k,v] if k }

    count_hash = Hash.new(0)
    study_phases.each{|x|count_hash[x] += 1 if x}
    gon.phase_counts=@phase_count=count_hash.collect{|k,v| [k,v] if k }
  end

  # GET /charts/1
  # GET /charts/1.json
  def show
  end

  # GET /charts/new
  def new
    @chart = Chart.new
  end

  # GET /charts/1/edit
  def edit
  end

  # POST /charts
  # POST /charts.json
  def create
    @chart = Chart.new(chart_params)

    respond_to do |format|
      if @chart.save
        format.html { redirect_to @chart, notice: 'Chart was successfully created.' }
        format.json { render :show, status: :created, location: @chart }
      else
        format.html { render :new }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /charts/1
  # PATCH/PUT /charts/1.json
  def update
    respond_to do |format|
      if @chart.update(chart_params)
        format.html { redirect_to @chart, notice: 'Chart was successfully updated.' }
        format.json { render :show, status: :ok, location: @chart }
      else
        format.html { render :edit }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charts/1
  # DELETE /charts/1.json
  def destroy
    @chart.destroy
    respond_to do |format|
      format.html { redirect_to charts_url, notice: 'Chart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chart
      sponsors=Study.all[0..20].collect{|s|s.sponsors}.flatten
      agencies=sponsors.collect{|a| a.agency}
      count_hash = Hash.new(0)
      agencies.each{|agency|count_hash[agency] += 1 if agency}
      @sponsor_count=count_hash.collect{|k,v| [k,v] if k }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chart_params
      params[:chart]
    end
end
