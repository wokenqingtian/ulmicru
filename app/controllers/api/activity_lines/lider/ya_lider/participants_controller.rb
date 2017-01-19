class Api::ActivityLines::Lider::YaLider::ParticipantsController < Api::ActivityLines::Lider::YaLider::ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    user = User.confirmed.where(email: params[:user][:email]).first
    if user
      user.update_attributes! params[:user]
      create_participant user
    else
      user_form = ActivityLines::Lider::YaLider::ParticipantUserForm.new User.new
      if user_form.submit params[:user]
        create_participant user_form
      else
        User.tech_admins.each do |user|
          send_notification user, user_form.model, :fail_participant_api_create
        end
        head :bad_request
      end
    end
  end

  private

  def create_participant(user)
    params[:activity_lines_lider_ya_lider_participant] = {}
    params[:activity_lines_lider_ya_lider_participant][:user_id] = user.id
    params[:activity_lines_lider_ya_lider_participant][:contest_id] = ::ActivityLines::Lider::YaLider.current.first.id
    participant_form = ::ActivityLines::Lider::YaLider::ParticipantForm.new_with_model
    if participant_form.submit params[:activity_lines_lider_ya_lider_participant]
      first_stage = participant_form.model.contest.first_stage
      ActivityLines::Lider::YaLider::Participation.create! participant_id: participant_form.model.id, stage_id: first_stage.id
      head :ok
      user.model.update_attributes! remote_avatar_url: "#{configus.it_projects.ul_lider.url}#{params[:user][:avatar]}"
    else
      User.tech_admins.each do |user|
        send_notification user, participant_form.model, :fail_api_create
      end
      head :bad_request
    end
  end
end
