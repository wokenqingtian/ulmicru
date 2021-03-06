class Web::Admin::UnviewedController < Web::Admin::ApplicationController
  skip_before_filter :check_declared_scopes
  skip_before_filter :collections_counts
  before_filter :unviewed_counts
  before_filter :check_notificatable_items

  def index
    if params[:items].present?
      items_class = params[:items].to_s
      if permitted_to? :review, items_class.gsub('/', '_')
        @unviewed = items_class.classify.constantize.need_to_review.page(params[:page]).decorate
        @tag = Tag.new
      else
        redirect_to not_found_page_path
      end
    end
  end

  private

  def check_notificatable_items
    any_items_key = @counts.keys.select { |k| @counts[k] != 0 }.first
    if any_items_key
      if params[:items].present?
        unless Concerns::NotificatableItems.items(current_user.id).map(&:to_s).include? params[:items]
          redirect_to params.except(:items)
        end
      else
        redirect_to admin_unviewed_index_path items: any_items_key
      end
    else
      unless current_user.role.user?
        redirect_to admin_path
      end
    end
  end

  def unviewed_counts
    @counts = Concerns::NotificatableItems.items(current_user.id).reduce({}) do |counts, item|
      counts.merge! item => item.to_s.classify.constantize.need_to_review.count
    end
  end
end
