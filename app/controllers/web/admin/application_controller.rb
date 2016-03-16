class Web::Admin::ApplicationController < Web::ApplicationController
  before_filter :authenticate_admin!
  before_filter :check_declared_scopes, only: :index
  before_filter :collections_counts, only: :index

  layout 'web/admin/application'

  include ModelsConcern
  include Concerns::DecoratorsConcern

  protected

  def choose_users
    @users = User.presented.decorate
  end

  def check_declared_scopes
    unless controller_name.classify.constantize.scopes.map(&:to_s).include? params[:scope]
      redirect_to params.except(:scope)
    end
  end

  def collections_counts
    @counts = {}
    decorator_class.collections.each do |collection|
      @counts[collection] = model_class.send(collection).count
    end
  end
end
