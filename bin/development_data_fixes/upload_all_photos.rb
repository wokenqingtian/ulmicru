if ARGV[0].present?
  image = Rails.root.join(ARGV[0]).open
  ActiveRecord::Base.logger.level = 1
  hash = { News => :photo, Event => :main_photo, ActivityLine => :logo, Member => :avatar, Delivery::Campaign => :image,
           Ckeditor::Picture => :data, Image => :file }
  hash.each do |type, attr|
    next if ARGV[1].present? && ARGV[1] != type.to_s.underscore
    puts type.to_s.green
    count = type.count
    type.find_each.with_index do |obj, index|
      unless obj.send(attr)&.present?
        obj.send "#{attr}=", image
        obj.save!
      end
      print "#{type} #{index} of #{count}\r"
    end
  end
else
  puts "You should send relative path to image".red
end
