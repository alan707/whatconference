class ConferencesController < ApplicationController
  before_action :set_conference, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorized_user, only: [:edit, :update, :destroy]

  exposes :conferences, :conference

  # GET /conferences
  def index
    @conferences = Conference.all
  end

  # GET /conferences/1
  def show
  end

  # GET /conferences/new
  def new
    @conference = current_user.conferences.build
  end

  # GET /conferences/1/edit
  def edit
  end

  # POST /conferences
  def create
    @conference = current_user.conferences.build(conference_params)

    respond_to do |format|
      if @conference.save
        format.html { redirect_to @conference, notice: 'Conference was successfully created.' }
        format.json { render :show, status: :created, location: @conference }
      else
        format.html { render :new }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conferences/1
  def update
    respond_to do |format|
      if @conference.update(conference_params)
        format.html { redirect_to @conference, notice: 'Conference was successfully updated.' }
        format.json { render :show, status: :ok, location: @conference }
      else
        format.html { render :edit }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1
  def destroy
    @conference.destroy
    respond_to do |format|
      format.html { redirect_to conferences_url, notice: 'Conference was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @conference.upvote_by current_user
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conference
      @conference = Conference.friendly.find(params[:id])
    end

    def authorized_user
      @conference = current_user.conferences.find_by(id: @conference.id)
      redirect_to conferences_path, notice: "Not authorized to edit this conference" if @conference.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conference_params
      params.require(:conference).permit(:title, :url, :location, :start_date, :end_date)
    end
end
