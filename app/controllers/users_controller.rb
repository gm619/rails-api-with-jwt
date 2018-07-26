class UsersController < ApplicationController
  before_action :authenticate_request, only: %i[show edit]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { status: 'User created successfully' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :bad_request
    end
  end

  def sign_in
    @user = User.find_by(email: params[:email].to_s.downcase)

    if @user.authenticate(params[:password])
      auth_token = JsonWebToken.encode(user_id: @user.id)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def show
    render json: { user: @current_user }, status: :ok
  end

  def edit
    if @current_user.update!(edit_params)
      render json: { user: @current_user }, status: :ok
    else
      render json: { errors: @current_user.errors.full_message }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :city)
  end

  def edit_params
    params.require(:user).permit(:email, :first_name, :last_name, :city)
  end
end
