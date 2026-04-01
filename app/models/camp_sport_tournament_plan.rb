class CampSportTournamentPlan < ApplicationRecord
  DEFAULT_ROUND_NOTE = "10 min Spiel, 5 min Wechsel".freeze

  ROUND_TEMPLATE = [
    [
      { type: :match, teams: [[1, :m], [2, :m]] },
      { type: :match, teams: [[4, :m], [5, :m]] },
      { type: :match, teams: [[2, :j], [4, :j]] },
      { type: :match, teams: [[1, :j], [3, :j]] },
      { type: :pause, teams: [[5, :j], [3, :m]] }
    ],
    [
      { type: :match, teams: [[3, :j], [5, :j]] },
      { type: :match, teams: [[1, :m], [3, :m]] },
      { type: :match, teams: [[1, :j], [4, :j]] },
      { type: :match, teams: [[2, :m], [4, :m]] },
      { type: :pause, teams: [[2, :j], [5, :m]] }
    ],
    [
      { type: :match, teams: [[3, :j], [4, :j]] },
      { type: :match, teams: [[2, :j], [5, :j]] },
      { type: :match, teams: [[2, :m], [3, :m]] },
      { type: :match, teams: [[1, :m], [5, :m]] },
      { type: :pause, teams: [[1, :j], [4, :m]] }
    ],
    [
      { type: :match, teams: [[3, :m], [5, :m]] },
      { type: :match, teams: [[1, :j], [2, :j]] },
      { type: :match, teams: [[1, :m], [4, :m]] },
      { type: :match, teams: [[4, :j], [5, :j]] },
      { type: :pause, teams: [[3, :j], [2, :m]] }
    ],
    [
      { type: :match, teams: [[3, :m], [4, :m]] },
      { type: :match, teams: [[2, :m], [5, :m]] },
      { type: :match, teams: [[2, :j], [3, :j]] },
      { type: :match, teams: [[1, :j], [5, :j]] },
      { type: :pause, teams: [[4, :j], [1, :m]] }
    ],
    [
      { type: :match, teams: [[1, :j], [4, :j]] },
      { type: :match, teams: [[1, :m], [2, :m]] },
      { type: :match, teams: [[3, :j], [5, :j]] },
      { type: :match, teams: [[4, :m], [5, :m]] },
      { type: :pause, teams: [[2, :j], [3, :m]] }
    ],
    [
      { type: :match, teams: [[2, :j], [5, :j]] },
      { type: :match, teams: [[3, :j], [4, :j]] },
      { type: :match, teams: [[1, :m], [5, :m]] },
      { type: :match, teams: [[2, :m], [3, :m]] },
      { type: :pause, teams: [[1, :j], [4, :m]] }
    ],
    [
      { type: :match, teams: [[1, :m], [4, :m]] },
      { type: :match, teams: [[1, :j], [3, :j]] },
      { type: :match, teams: [[3, :m], [5, :m]] },
      { type: :match, teams: [[2, :j], [4, :j]] },
      { type: :pause, teams: [[5, :j], [2, :m]] }
    ],
    [
      { type: :match, teams: [[1, :j], [2, :j]] },
      { type: :match, teams: [[4, :j], [5, :j]] },
      { type: :match, teams: [[2, :m], [4, :m]] },
      { type: :match, teams: [[1, :m], [3, :m]] },
      { type: :pause, teams: [[3, :j], [5, :m]] }
    ],
    [
      { type: :match, teams: [[2, :m], [5, :m]] },
      { type: :match, teams: [[3, :m], [4, :m]] },
      { type: :match, teams: [[1, :j], [5, :j]] },
      { type: :match, teams: [[2, :j], [3, :j]] },
      { type: :pause, teams: [[4, :j], [1, :m]] }
    ]
  ].freeze

  belongs_to :camp_team

  validates :round_interval_minutes, numericality: { only_integer: true, greater_than: 0 }
  validates :start_time_minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24 * 60 }

  def reset_to_defaults!
    update!(default_attributes)
  end

  def start_hour
    start_time_minutes / 60
  end

  def start_minute
    start_time_minutes % 60
  end

  def round_rows
    ROUND_TEMPLATE.each_with_index.map do |slots, index|
      {
        round: index + 1,
        time_label: minutes_to_label(start_time_minutes + (index * round_interval_minutes)),
        slots: slots.each_with_index.map do |slot, slot_index|
          {
            station_label: station_name(slot_index + 1),
            value: slot_value(slot)
          }
        end
      }
    end
  end

  def group_name(number)
    self["group#{number}_name"].presence || "Gruppe #{number}"
  end

  def station_name(number)
    self["station#{number}_name"].presence || (number == 5 ? "Station 5 / Pause" : "Station #{number}")
  end

  private

  def default_attributes
    {
      start_time_minutes: 15 * 60,
      round_interval_minutes: 15,
      round_note: DEFAULT_ROUND_NOTE,
      group1_name: nil,
      group2_name: nil,
      group3_name: nil,
      group4_name: nil,
      group5_name: nil,
      station1_name: nil,
      station2_name: nil,
      station3_name: nil,
      station4_name: nil,
      station5_name: nil
    }
  end

  def slot_value(slot)
    first_team, second_team = slot[:teams]
    connector = slot[:type] == :pause ? " / " : " vs "

    "#{team_label(first_team)}#{connector}#{team_label(second_team)}"
  end

  def team_label(team)
    number, gender = team
    "#{group_name(number)} #{gender.to_s.upcase}"
  end

  def minutes_to_label(total_minutes)
    hours = (total_minutes / 60) % 24
    minutes = total_minutes % 60
    format("%02d:%02d", hours, minutes)
  end
end
