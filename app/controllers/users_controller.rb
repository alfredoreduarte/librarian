class UsersController < ApplicationController
  before_action :set_user, only: [:show, :articles, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/1/articles.json
  def articles
    @articles = @user.articles
  end

  # POST /users/status.json
  def status
    user = User.find_by(token: params[:token])
    if !user.nil?
      render plain: user.status
    else
      render plain: 'nonexistant'
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users/update_timezone.json
  def update_timezone
    @user = User.find_by(token: params[:token])
    @user.update(timezone: params[:timezone])
    render @user
  end

  # POST /users/unsubscribe.json
  def unsubscribe
    @user = User.find_by(token: params[:token])
    @user.update(status: 1)
    render @user
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:token, :email, :phone, :timezone, :ip_address, :project_id, :status)
    end
end
