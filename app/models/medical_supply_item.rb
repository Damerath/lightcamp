class MedicalSupplyItem < ApplicationRecord
  CATEGORY_ORDER = ["Medikamente", "Salben", "Werkzeuge", "Verbandsmaterial", "Sonstiges"].freeze

  validates :category, :name, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(Arel.sql(category_case_sql), :position, :name, :id) }

  def self.grouped_for_view
    ordered.group_by(&:category)
  end

  def self.category_case_sql
    @category_case_sql ||= begin
      clauses = CATEGORY_ORDER.each_with_index.map { |category, index| "WHEN #{connection.quote(category)} THEN #{index}" }.join(" ")
      "CASE category #{clauses} ELSE #{CATEGORY_ORDER.length} END"
    end
  end
end
