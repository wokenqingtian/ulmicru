class Web::NewsDecorator < Draper::Decorator
  delegate_all

  def short_lead
    "#{model.body.first(50)}..."
  end

  def lead 
    "#{model.body.first(250)}..."
  end

  def description_lead
    "#{model.body.first(200)}..."
  end

  def long_lead
    "#{model.body.first(600)}..."
  end

  def publish_date_time
    l(object.published_at)[0..22]
  end

end
