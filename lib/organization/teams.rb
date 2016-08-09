module Organization
  module Teams
    def presidium
      Team.find_by_title 'Президиум'
    end

    def area_headers
      Team.find_by_title 'Руководители областных программ и проектов МИЦ'
    end
    
    def positions_associate_with_team(positions, team)
      positions_structure ||= YAML.load_file("#{Rails.root}/lib/yaml/positions.yml").with_indifferent_access
      team_positions = positions_structure[:positions][:team].map do |position|
        if position.is_a? String
          "#{position.mb_chars.capitalize.to_s} #{team.full_title(:genitive)}"
        elsif position.is_a? Hash
          deputy = position[:deputy]
          deputy.map do |name|
            "Заместитель #{genitive(name)} #{team.full_title(:genitive)}"
          end
        end
      end
      positions.where title: team_positions
    end
  end
end
