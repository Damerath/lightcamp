class AdminMedicalSupplyListsController < ApplicationController
  before_action :require_admin

  def show
    load_collection
  end

  def create
    item = MedicalSupplyItem.new(medical_supply_item_params.merge(position: next_position))

    if item.save
      MedicalSupplyChange.log!(user: current_user, item_name: item.name, change_type: "create", change_summary: summary_for(item, "Angelegt"))
      redirect_to admin_medical_supply_list_path, notice: "Eintrag wurde gespeichert."
    else
      redirect_to admin_medical_supply_list_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def update
    item = MedicalSupplyItem.find(params[:id])
    previous = item.attributes.slice("category", "usage_purpose", "name", "quantity", "expires_on_label", "notes", "missing", "opened")

    if item.update(medical_supply_item_params)
      summary = build_update_summary(previous, item)
      MedicalSupplyChange.log!(user: current_user, item_name: item.name, change_type: "update", change_summary: summary) if summary.present?
      redirect_to admin_medical_supply_list_path, notice: "Eintrag wurde aktualisiert."
    else
      redirect_to admin_medical_supply_list_path, alert: item.errors.full_messages.to_sentence
    end
  end

  def destroy
    item = MedicalSupplyItem.find(params[:id])
    item_name = item.name
    summary = summary_for(item, "Entfernt")
    item.destroy
    MedicalSupplyChange.log!(user: current_user, item_name: item_name, change_type: "destroy", change_summary: summary)
    redirect_to admin_medical_supply_list_path, notice: "Eintrag wurde entfernt."
  end

  private

  def load_collection
    @medical_supply_items = MedicalSupplyItem.grouped_for_view
    @medical_supply_changes = MedicalSupplyChange.recent_first.limit(50)
  end

  def medical_supply_item_params
    params.require(:medical_supply_item).permit(:category, :usage_purpose, :name, :quantity, :expires_on_label, :notes, :missing, :opened)
  end

  def next_position
    (MedicalSupplyItem.maximum(:position) || -1) + 1
  end

  def summary_for(item, prefix)
    parts = []
    parts << "Kategorie #{item.category}"
    parts << "Verwendungszweck #{item.usage_purpose}" if item.usage_purpose.present?
    parts << "Menge #{item.quantity}" if item.quantity.present?
    parts << "Ablauf #{item.expires_on_label}" if item.expires_on_label.present?
    parts << "Anmerkung #{item.notes}" if item.notes.present?
    parts << "fehlt" if item.missing?
    parts << "angebrochen" if item.opened?
    "#{prefix}: #{parts.join(', ')}"
  end

  def build_update_summary(previous, item)
    changes = []
    changes << "Kategorie von #{previous['category']} auf #{item.category}" if previous["category"] != item.category
    changes << "Verwendungszweck von #{previous['usage_purpose'].presence || '-'} auf #{item.usage_purpose.presence || '-'}" if previous["usage_purpose"] != item.usage_purpose
    changes << "Name von #{previous['name']} auf #{item.name}" if previous["name"] != item.name
    changes << "Menge von #{previous['quantity'].presence || '-'} auf #{item.quantity.presence || '-'}" if previous["quantity"] != item.quantity
    changes << "Ablauf von #{previous['expires_on_label'].presence || '-'} auf #{item.expires_on_label.presence || '-'}" if previous["expires_on_label"] != item.expires_on_label
    changes << "Anmerkung von #{previous['notes'].presence || '-'} auf #{item.notes.presence || '-'}" if previous["notes"] != item.notes
    changes << "Fehlt von #{previous['missing'] ? 'Ja' : 'Nein'} auf #{item.missing? ? 'Ja' : 'Nein'}" if previous["missing"] != item.missing
    changes << "Angebrochen von #{previous['opened'] ? 'Ja' : 'Nein'} auf #{item.opened? ? 'Ja' : 'Nein'}" if previous["opened"] != item.opened
    changes.present? ? "Aktualisiert: #{changes.join('; ')}" : nil
  end

  def require_admin
    redirect_to root_path, alert: "Kein Zugriff" unless current_user&.admin?
  end
end
