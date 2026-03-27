class UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:update, :destroy]

  def index
    @users = User.order(:last_name, :first_name, :email)
    @selected_user = User.find_by(id: params[:user_id]) if params[:modal] == "edit_user"
  end

  def update
    if demoting_last_admin?
      redirect_to users_path(modal: "edit_user", user_id: @user.id), alert: "Der letzte Admin kann nicht auf user gesetzt werden."
      return
    end

    if @user.update(user_params)
      redirect_to users_path, notice: "Benutzer wurde aktualisiert."
    else
      redirect_to users_path(modal: "edit_user", user_id: @user.id), alert: @user.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @user == current_user
      redirect_to users_path(modal: "edit_user", user_id: @user.id), alert: "Du kannst deinen eigenen Benutzer nicht loeschen."
      return
    end

    if @user.admin? && User.where(role: "admin").count <= 1
      redirect_to users_path(modal: "edit_user", user_id: @user.id), alert: "Der letzte Admin kann nicht geloescht werden."
      return
    end

    @user.destroy
    redirect_to users_path, notice: "Benutzer wurde geloescht."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role)
  end

  def demoting_last_admin?
    @user.admin? && user_params[:role] != "admin" && User.where(role: "admin").count <= 1
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Kein Zugriff"
    end
  end
end
