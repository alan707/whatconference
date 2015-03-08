class ConferencesController < ApplicationController
  before_action :set_conference, only: [:show, :edit, :update, :destroy, :follow]
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :follow]
  before_action :authorize_conference

  exposes :conferences, :conference

  # GET /conferences
  def index
    query = params[:query].andand.strip
    query = '*' if query.blank?
    search_conferences query, page: params[:page], per_page: 40
    # Prevent N queries to load the count of followers
    Conference.eager_load_followers_count @conferences
  end

  # GET /conferences/autocomplete?query=name
  def autocomplete
    if params[:prefetch]
      search_conferences('*', limit: 1000)
    else
      search_conferences(params[:query], limit: 10)
    end
  end

  # GET /conferences/1
  def show
  end

  # GET /conferences/new
  def new
    @conference = current_user.conferences.build
    @conference.start_date = 1.day.from_now.to_date
    @conference.title = params[:title]
  end

  # GET /conferences/1/edit
  def edit
  end

  # POST /conferences
  def create
    @conference = current_user.created_conferences.build(conference_params)

    respond_to do |format|
      if @conference.save
        @conference.follow @current_user

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

  def follow
    @conference.follow current_user
    redirect_to :back
  end

  private

  def search_conferences(query, options = {})
    # Search and boost matches in title
    options.reverse_merge fields: [{"title^4" => :word_start}]
    @conferences = Conference.search(query, options)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_conference
    @conference = Conference.friendly.find(params[:id])
  end

  def authorize_conference
    authorize (@conference || @conferences || Conference)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def conference_params
    params.require(:conference).permit(:title, :url, :location, :city_state, :start_date, :end_date, :date_range)
  end

  def filter_by_date(start_at, end_at)
    if start_at.present? && end_at.present?
      @conferences = @conferences.occurs_within(start_at..end_at)
    end
  end
end
