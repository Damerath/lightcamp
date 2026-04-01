module ApplicationHelper
  GENERAL_EXPECTATIONS_DESCRIPTION = <<~TEXT.freeze
    Lightcamp-Richtlinien und Vision
    - Lightcamp ist ein Camp, das sich Gott und seiner Gemeinde verpflichtet weiß und evangelistisch-missionarische Freizeitarbeit aufbauen, ein effektives und spannendes Freizeitprogramm gestalten und an der Qualität des Camps arbeiten möchte.
    - Die Lightcamp-Freizeiten wollen Teilnehmenden helfen, auf folgende Fragen Antworten zu finden:
    - Warum brauche ich Gott?
    - Wie kann ich ihn finden?
    - Wie kann ich mit ihm leben?

    Persönliche Erwartungen
    - Leidenschaftliche Liebe zu Gott und Menschen.
    - Ausgeglichene, belastbare und zuverlässige Persönlichkeit.
    - Vorbild eines geistlichen Christen mit intaktem Glaubensleben und ungeteiltem Herzen für Gott.

    Haltung auf dem Camp
    - Fördert und lebt christliche Werte, geschwisterliche Atmosphäre und menschlichen Respekt.
    - Führt ein biblisch konformes Leben und Verhalten auf dem Camp.
    - Vermeidet bewusst nicht-christliche Einflüsse in Musik, Sprache, Kleidung und zwischenmenschlichem Umgang.
  TEXT

  DESCRIPTION_HEADINGS = [
    "Lightcamp-Richtlinien und Vision",
    "Persönliche Erwartungen",
    "Haltung auf dem Camp",
    "Definition",
    "Erwartung / Haltung",
    "Ansprechperson",
    "Aufgabenbereiche",
    "Das Budget",
    "Tipps",
    "Hilfsmaterial / Spielideen",
    "Hilfestellungen",
    "Anlage"
  ].freeze

  def render_structured_description(text)
    return content_tag(:p, "Noch keine Aufgabenbeschreibung hinterlegt.", class: "text-slate-500 dark:text-slate-400") if text.blank?

    nodes = []
    list_items = []

    flush_list = lambda do
      next if list_items.empty?

      nodes << content_tag(:ul, safe_join(list_items), class: "space-y-2 pl-5 text-sm leading-7 text-slate-700 marker:text-red-500 dark:text-slate-300")
      list_items = []
    end

    normalize_description_text(text).each do |line|
      if line.blank?
        flush_list.call
        next
      end

      if description_heading?(line)
        flush_list.call
        nodes << content_tag(:h4, line, class: "mt-6 text-base font-semibold text-slate-900 first:mt-0 dark:text-slate-100")
      elsif description_subheading?(line)
        flush_list.call
        nodes << content_tag(:h5, line, class: "mt-5 text-sm font-semibold uppercase tracking-[0.16em] text-slate-500 dark:text-slate-400")
      elsif description_bullet?(line)
        list_items << content_tag(:li, strip_description_bullet(line))
      else
        flush_list.call
        nodes << content_tag(:p, line, class: "text-sm leading-7 text-slate-700 dark:text-slate-300")
      end
    end

    flush_list.call
    safe_join(nodes)
  end

  private

  def normalize_description_text(text)
    text.to_s.gsub("\r\n", "\n").split("\n").map(&:strip)
  end

  def description_heading?(line)
    DESCRIPTION_HEADINGS.include?(line)
  end

  def description_subheading?(line)
    line.match?(/^\d+\.\s+/)
  end

  def description_bullet?(line)
    line.start_with?("- ", "• ")
  end

  def strip_description_bullet(line)
    line.sub(/\A(-|•)\s*/, "")
  end
end
