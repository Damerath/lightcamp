class ProfilesController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profil wurde gespeichert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :gender,
      :birthdate,
      :phone,
      :first_aider,
      :sound_tech,
      :instruments,
      :other_skills
    )
  end
end