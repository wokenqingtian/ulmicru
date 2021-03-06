class Web::Admin::ActivityLines::Lider::YaLidersController < Web::Admin::ActivityLines::ApplicationController
  before_filter :choose_events, only: [ :new,  :edit ]

  def index
    if params[:search]
      ya_liders = ActivityLines::Lider::YaLider.search_everywhere params[:search]
    else
      ya_liders = ActivityLines::Lider::YaLider.send params[:scope]
    end
    @ya_liders = ya_liders.page(params[:page]).decorate
  end

  def new
    @ya_lider_form = ::ActivityLines::Lider::YaLiderForm.new_with_model
    @ya_lider_form.build_fair_idea!
  end

  def show
    @ya_lider = ::ActivityLines::Lider::YaLider.includes(:tokens).where(id: params[:id]).first.decorate
    current_participants = if @ya_lider.current_stage.present?
                             if params[:search].present?
                               ::ActivityLines::Lider::YaLider::Participant.where(
                                 id: (@ya_lider.current_stage.participants.search_everywhere(params[:search]).map(&:id) &
                                      @ya_lider.current_stage.current_participants.map(&:id)))
                             else
                               @ya_lider.current_stage.participants.active
                             end
                           end
     @current_participants = ::ActivityLines::Lider::YaLider::ParticipantDecorator.decorate_collection(
       Kaminari.paginate_array(current_participants).page(params[:page])) if current_participants.present?
  end

  def create
    @ya_lider_form = ::ActivityLines::Lider::YaLiderForm.new_with_model
    if @ya_lider_form.submit params[:activity_lines_lider_ya_lider]
      Token.create! record_type: 'ActivityLines::Lider::YaLider', record_id: @ya_lider_form.model.id 
      redirect_to admin_activity_lines_lider_ya_liders_path
    else
      choose_events
      render action: :new
    end
  end

  def edit
    @ya_lider_form = ::ActivityLines::Lider::YaLiderForm.find_with_model params[:id]
    @ya_lider_form.build_fair_idea!
  end

  def update
    @ya_lider_form = ::ActivityLines::Lider::YaLiderForm.find_with_model params[:id]
    if @ya_lider_form.submit params[:activity_lines_lider_ya_lider]
      redirect_to edit_admin_activity_lines_lider_ya_lider_path @ya_lider_form.model
    else
      choose_events
      render action: :edit
    end
  end

  def destroy
    @ya_lider = ::ActivityLines::Lider::YaLider.find params[:id]
    @ya_lider.remove
    redirect_to admin_activity_lines_lider_ya_liders_path
  end

  private

  def choose_events
    @events = Event.presented.reverse
  end
end
