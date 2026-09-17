module LeadershipAnnualTasksHelper
  def annual_task_month_options
    (1..12).map { |month| [I18n.l(Date.new(2024, month, 1), format: "%B"), month] }
  end

  def annual_task_day_options
    (1..31).to_a
  end
end
