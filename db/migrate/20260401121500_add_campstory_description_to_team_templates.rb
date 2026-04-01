class AddCampstoryDescriptionToTeamTemplates < ActiveRecord::Migration[7.1]
  def up
    template = TeamTemplate.find_or_create_by!(name: "Campstory")

    template.update!(
      description: <<~TEXT
        Definition
        Die Campstory-Mitarbeiter sind die Personen im Camp, die die inhaltliche und kreative Rahmengeschichte der Freizeit entwickeln und umsetzen. Sie gestalten durch Anspiele und Szenen einen roten Faden, der sich durch die gesamte Freizeit zieht und die Bibelarbeiten thematisch unterstützt. Sie unterliegen der Verantwortung der Lightcamp-, Freizeit- und Programmleitung und arbeiten eng mit diesen zusammen. Ihr Handeln soll für Menschen und Gott transparent und vor ihnen verantwortbar sein.

        Erwartung / Haltung
        - Kreativität, Teamfähigkeit und ein gutes Gespür für die Lebenswelt von Kindern und Teens.
        - Inhalte verständlich, ansprechend und lebensnah vermitteln.
        - Bereitschaft, Verantwortung zu übernehmen und aktiv vor Menschen zu stehen.

        Aufgabenbereiche
        1. Vor der Freizeit
        - Die Campstory gemeinsam auf Grundlage des Camp-Themas und der Bibelarbeiten entwickeln.
        - Einen roten Faden für die gesamte Freizeit erarbeiten.
        - Anspiele schreiben, die gezielt auf die Bibelarbeiten hinleiten.
        - Wiederkehrende Charaktere, Spannungsbögen und gegebenenfalls Cliffhanger planen.
        - Szenen kreativ ausarbeiten, inklusive Dialogen, Rollen und Dramaturgie.
        - Sich mit Programmleitern, Prediger und Kreativteam abstimmen.
        - Rollen verteilen und weitere Mitarbeitende als Darsteller einbinden.
        - Eine sinnvolle Probenstruktur vorbereiten.

        2. Während der Freizeit
        - Die Campstory in Abendveranstaltungen und gegebenenfalls Zwischenszenen darstellen.
        - Anspiele anleiten und durchführen.
        - Kurze Proben vor den jeweiligen Einsätzen organisieren.
        - Schauspieler koordinieren und anleiten.
        - Sicherstellen, dass die Story verständlich, spannend und zielgerichtet bleibt.
        - Die Story flexibel an die Dynamik der Freizeit anpassen.
        - Darsteller motivieren und begleiten.
        - Mit Technik und Programmleitung eng zusammenarbeiten.
        - Für Hilfe und Unterstützung jederzeit ansprechbar sein.

        3. Nach der Freizeit
        - Die Campstory im Team reflektieren.
        - Gemeinsam auswerten, was die Teilnehmenden erreicht hat und was unverständlich blieb.
        - Ideen und Verbesserungen für zukünftige Freizeiten dokumentieren.

        Tipps
        - Die Story soll die Teilnehmenden emotional abholen und neugierig auf die Bibelarbeiten machen.
        - Weniger ist oft mehr: lieber eine klare Botschaft als eine zu komplexe Handlung.
        - Humor, Spannung und Identifikationsfiguren helfen beim Zugang.
        - Gute Vorbereitung spart auf der Freizeit viel Stress.
        - Der Fokus bleibt immer: Die Story dient der Botschaft, nicht umgekehrt.
      TEXT
    )
  end

  def down
    TeamTemplate.find_by(name: "Campstory")&.update!(description: nil)
  end
end
