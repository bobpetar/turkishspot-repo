class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => [:show, :index]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all
    @places = Place.all
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
    @cate = Category.limit(10)
    @places = Place.order(created_at: :desc).paginate(page: params[:page], per_page: 15)
    @cities = City.limit(10)
    @blog = Blog.last
  end

  # GET /cities/new
  def new
    @city = City.new
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)
    @city.user = current_user
    respond_to do |format|
      if @city.save
        format.html { redirect_to new_place_path, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:first_name, :last_name, :email, :about, :city_name, :user_id)
    end
    
    def require_same_user
      if current_user != @city.user and !current_user.admin?
        flash[:danger] = "You can only edit or delete your own cities."
        redirect_to root_path
      end
    end
end
