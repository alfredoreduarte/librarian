class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(created_at: :desc).all
  end

  # GET /per_day
  # GET /per_day.json
  def per_day
    @users = User.all.group_by {|t| t.created_at.to_date.to_s(:db) }.map {|k,v| {created_at: k, count: v.length}}
  end

  def group_by_criteria
    created_at.to_date.to_s(:db)
  end

  # GET /users/1
  # GET /users/1.json
  def show
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
    # @user = User.new(user_params)
    @user = User.find_or_initialize_by(token: params[:token])
    @user.update(user_params)

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
    if !@user.nil?
      @user.update(status: 1)
      render @user
    else
      render plain: 'ok'
    end
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
      params.require(:user).permit(:token, :name, :last_name, :email, :phone, :timezone, :ip_address, :project_id, :status)
    end
end
