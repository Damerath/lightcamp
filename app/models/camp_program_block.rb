class CampProgramBlock < ApplicationRecord
  COLOR_THEMES = {
    "blue" => {
      label: "Blau",
      card: "bg-blue-100 text-blue-950 border-blue-300 dark:bg-blue-950/70 dark:text-blue-50 dark:border-blue-800",
      accent: "bg-blue-500"
    },
    "green" => {
      label: "Grün",
      card: "bg-emerald-100 text-emerald-950 border-emerald-300 dark:bg-emerald-950/70 dark:text-emerald-50 dark:border-emerald-800",
      accent: "bg-emerald-500"
    },
    "amber" => {
      label: "Orange",
      card: "bg-amber-100 text-amber-950 border-amber-300 dark:bg-amber-950/70 dark:text-amber-50 dark:border-amber-800",
      accent: "bg-amber-500"
    },
    "red" => {
      label: "Rot",
      card: "bg-rose-100 text-rose-950 border-rose-300 dark:bg-rose-950/70 dark:text-rose-50 dark:border-rose-800",
      accent: "bg-rose-500"
    },
    "violet" => {
      label: "Violett",
      card: "bg-violet-100 text-violet-950 border-violet-300 dark:bg-violet-950/70 dark:text-violet-50 dark:border-violet-800",
      accent: "bg-violet-500"
    },
    "teal" => {
      label: "Türkis",
      card: "bg-teal-100 text-teal-950 border-teal-300 dark:bg-teal-950/70 dark:text-teal-50 dark:border-teal-800",
      accent: "bg-teal-500"
    },
    "pink" => {
      label: "Pink",
      card: "bg-pink-100 text-pink-950 border-pink-300 dark:bg-pink-950/70 dark:text-pink-50 dark:border-pink-800",
      accent: "bg-pink-500"
    },
    "yellow" => {
      label: "Gelb",
      card: "bg-yellow-100 text-yellow-950 border-yellow-300 dark:bg-yellow-950/70 dark:text-yellow-50 dark:border-yellow-800",
      accent: "bg-yellow-500"
    },
    "slate" => {
      label: "Grau",
      card: "bg-slate-200 text-slate-900 border-slate-300 dark:bg-slate-800 dark:text-slate-100 dark:border-slate-600",
      accent: "bg-slate-500"
    }
  }.freeze

  belongs_to :camp_team

  validates :title, presence: true
  validates :color, presence: true, inclusion: { in: COLOR_THEMES.keys }
  validates :starts_at_minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24 * 60 }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :starts_at_minutes, :created_at) }

  def start_hour
    format("%02d", starts_at_minutes / 60)
  end

  def start_minute
    format("%02d", starts_at_minutes % 60)
  end

  def starts_at_label
    "#{start_hour}:#{start_minute}"
  end

  def color_card_classes
    COLOR_THEMES.fetch(color, COLOR_THEMES["blue"])[:card]
  end

  def color_accent_class
    COLOR_THEMES.fetch(color, COLOR_THEMES["blue"])[:accent]
  end
end
