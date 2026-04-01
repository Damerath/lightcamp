class PopulateTeamTemplateDescriptions < ActiveRecord::Migration[7.1]
  def up
    descriptions.each do |name, attributes|
      template = TeamTemplate.find_or_create_by!(name: name)
      template.update!(attributes)
    end
  end

  def down
  end

  private

  def descriptions
    {
      "Freizeitleiter" => {
        description: <<~TEXT
          Definition
          Ein Freizeitleiter ist die Person im Camp, die dem gesamten Mitarbeiterteam, den Teilnehmenden, dem Freizeitprogramm und dem Lager in geistlicher und fachlicher Hinsicht vorsteht. Er trägt die Verantwortung gegenüber Lightcamp- und Gemeindeleitung und ist letzte Entscheidungsinstanz bei Konflikten und besonderen Situationen.

          Erwartung / Haltung
          - Leitungsgabe von Gott und möglichst Erfahrung in der Camparbeit.
          - Transparenz vor Gott und Menschen.
          - Klare geistliche Ausrichtung und dienende Leiterschaft.

          Ansprechperson
          Daniel Pritzkau (+49 172 5378566)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Bereichsleiter-Meeting einberufen und das Gesamtprogramm zusammenführen.
          - Freizeitziele, Ausrichtung und fehlende Positionen klären.
          - Den Anreisetag mit den Bereichsleitern vorbereiten.

          2. Während der Freizeit
          - Mitarbeitertage planen und Mitarbeitende in ihre Bereiche einweisen.
          - Lightcamp-Richtlinien vorstellen und deren Einhaltung gewährleisten.
          - Die morgendliche Mitarbeiter-Tagesbesprechung leiten.
          - Die Bereichsleitung führen, Feedbackgespräche führen und die Freizeit geistlich ausrichten.
          - Den Tagesabschluss mit Snack, Austausch und Gebet mitgestalten.
          - Den harmonischen Verlauf der Freizeit gewährleisten.
          - Ansprechpartner für Seelsorge, Konflikte, Krankheitsfälle, Besuche und organisatorische Entscheidungen sein.
          - Die Nachtruhe der Mitarbeitenden durchsetzen.

          3. Nach der Freizeit
          - Abschließende Feedbackrunde mit allen Mitarbeitenden durchführen.
          - Mitarbeitende verabschieden und MA-Geschenke überreichen.
          - Das Aufräumen gemeinsam mit den Programmleitern koordinieren.
        TEXT
      },
      "Programmleiter" => {
        description: <<~TEXT
          Definition
          Die Programmleiter sind für das gesamte Freizeit-, Rahmen- und Bühnenprogramm verantwortlich. Sie arbeiten unter Lightcamp- und Freizeitleitung und gestalten den roten Faden der Freizeit.

          Erwartung / Haltung
          - Leitungs- und Gestaltungsgabe von Gott.
          - Kreativer Blick für ein geistlich und pädagogisch starkes Programm.

          Ansprechperson
          Peter Voth (+49 157 88077651)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Das Freizeitprogramm auf Grundlage der Bibelarbeiten und des Camp-Themas planen.
          - Tages- und Wochenabläufe, Abendveranstaltungen und Alternativprogramm vorbereiten.
          - Das Programm bei der Mitarbeiterschulung vorstellen.
          - Am BL-Meeting teilnehmen und das Programm mit den anderen Bereichen abstimmen.
          - Benötigte Materialien einkaufen und vorbereiten.

          2. Während der Freizeit
          - Den gesamten Freizeittagesablauf leiten und organisieren.
          - Programminfos in der MATB weitergeben.
          - Tagesbewertungen und Siegerehrungen koordinieren.
          - Abendveranstaltungen moderieren, gestalten und durchführen.
          - Für Hilfe und Unterstützung jederzeit ansprechbar sein.

          3. Nach der Freizeit
          - Die Abschlussveranstaltung mit Eltern und Teilnehmenden gestalten.
          - Das Aufräumen gemeinsam mit dem Freizeitleiter koordinieren.

          Das Budget
          - Budget: 250 €
          - Kassenbons aufheben.
          - Günstige Webseiten nutzen.
          - Mit anderen Bereichen und Freizeiten abstimmen.
          - Teurere Anschaffungen vorher absprechen.

          Tipps
          - Sprecht mit früheren PLs.
          - Plant frühzeitig und detailliert.
          - Arbeitet mit To-Do-Listen.
          - Trefft euch mit den PLs der anderen Freizeiten.
        TEXT
      },
      "Gruppenleiter" => {
        description: <<~TEXT
          Definition
          Gruppenleiter sind die direkten Verantwortlichen für eine Teilnehmenden-Gruppe. Sie tragen geistliche, soziale und organisatorische Verantwortung für ihre Gruppe.

          Erwartung / Haltung
          - Leitungs- und Lehrgabe von Gott.
          - Idealerweise Erfahrung in Kinder- oder Teeniearbeit.

          Ansprechperson
          Tobias Johannesmeyer (+49 172 7704052)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Bibelarbeiten gründlich vorbereiten.
          - Sich mit Altersgruppe und Themen der Teilnehmenden auseinandersetzen.

          2. Während der Freizeit
          - An der MATB teilnehmen.
          - Die eigene Gruppe im geistlichen, sozialen, sportlich-kreativen und häuslichen Bereich führen.
          - Bibelarbeiten, geistliche Gespräche, Gebetsgemeinschaften und Beziehungsarbeit gestalten.
          - Ordnung, Dienste, Hygiene und Gruppengemeinschaft fördern.
          - Regelmäßige Feedback- und Smalltalk-Gespräche mit den Teilnehmenden führen.
          - Für Hilfe und Unterstützung jederzeit ansprechbar sein.

          3. Nach der Freizeit
          - Einen wertschätzenden Gruppenabschluss gestalten.
          - Die Teilnehmenden in der Nacharbeit weiter begleiten.

          Tipps
          - Schafft eine ruhige und gemütliche Atmosphäre für Bibelarbeiten.
          - Bereitet Fragen, Spiele und Rituale für zwischendurch vor.
          - Nutzt Tagesabschlüsse für Austausch und Gebet.
          - Schafft eine wertschätzende Abschiedskultur.
        TEXT
      },
      "Sport" => {
        description: <<~TEXT
          Definition
          Die Sportmitarbeiter gestalten gemeinsam das Sport- und Outdoorprogramm der Freizeit. Sie arbeiten im Team unter der Verantwortung von Lightcamp-, Freizeit- und Sportleitung.

          Erwartung / Haltung
          - Kreativität, Sportlichkeit und idealerweise Erfahrung mit Sportangeboten für Kinder und Jugendliche.
          - Freude daran, Teilnehmende zu motivieren und Gemeinschaft zu stärken.

          Ansprechperson
          Marianne Neumann (+49 176 87967704)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Sportprogramm, Wanderung, Pflichtsport, Freisport und Nachtspiel vorbereiten.
          - Wetter-Alternativen mitdenken.
          - Materialien einkaufen und mit anderen Freizeiten abstimmen.
          - Absprachen mit dem Hausmeister und Einweisungen für besondere Geräte wahrnehmen.

          2. Während der Freizeit
          - Teilnahme an der MATB.
          - Teilnehmende wecken und bei der ersten AV vorstellen.
          - Das gesamte Outdoorprogramm durchführen und an das Wetter anpassen.
          - Tägliche Reflexion im Sportteam halten.
          - Siege und Tagesauswertungen unterstützen.
          - Sportmaterial verantwortungsvoll aufbauen, säubern und wegräumen.
          - Beziehungen zu Teilnehmenden bauen und ansprechbar sein.

          3. Nach der Freizeit
          - Sportmaterial säubern, sortieren und ordentlich zurückräumen.
          - Für eine gute Übergabe an die nächste Freizeit sorgen.

          Das Budget
          - Budget: 200 €
          - Kassenbons aufheben.
          - Günstige Internetseiten nutzen.
          - Mit anderen Bereichen und Freizeiten abstimmen.
          - Teurere Anschaffungen vorher absprechen.

          Tipps
          - Sprecht mit früheren Sportmitarbeitern.
          - Plant frühzeitig und teilt die Tage im Team auf.
          - Nutzt To-Do-Listen.
          - Schaut euch den LC-Materialraum mit Spielanleitungen an.
        TEXT,
        responsible_description: <<~TEXT
          Definition
          Der Sportleiter trägt die geistliche und fachliche Verantwortung für das Outdoorprogramm und das Sportteam. Er ist Vermittler zwischen seinem Team und den anderen Verantwortlichen der Freizeit.

          Erwartung / Haltung
          - Leitungs- und Gestaltungsgabe von Gott.
          - Sportlichkeit und idealerweise Erfahrung im Bereich Outdoor und Sport mit Kindern.

          Ansprechperson
          Marianne Neumann (+49 176 87967704)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Teilnahme am BL-Meeting und Abstimmung mit den anderen Bereichen.
          - Das gesamte Outdoorprogramm, Wanderung, Pflichtsport, Freisport und Siegerehrungen planen.
          - Material einkaufen, Einweisungen koordinieren und mit dem Hausmeister die Flächen abstimmen.

          2. Während der Freizeit
          - Teilnahme an der MATB und Vorstellung bei der ersten AV.
          - Das Sportteam leiten, informieren und motivieren.
          - Tägliche Reflexions- und Austauschrunden im Sportteam anleiten.
          - Programmdetails und Absprachen mit anderen Bereichen koordinieren.
          - Auf verantwortungsvollen Umgang mit Material und gute Abläufe achten.
          - Beziehungen zu Mitarbeitenden und Teilnehmenden pflegen.

          3. Nach der Freizeit
          - Outdoorinventar und LC-Materialraum ordnen, warten und Schäden melden.
          - Die Übergabe an nachfolgende Sportteams koordinieren.
        TEXT
      },
      "DIY" => {
        description: <<~TEXT
          Definition
          Das Kreativteam ist für das gesamte Kreativprogramm verantwortlich und arbeitet unter Lightcamp- und Freizeitleitung. Es soll Teilnehmende in ihrer Kreativität fördern und sie aktiv einbinden.

          Erwartung / Haltung
          - Kreative Begabung und idealerweise Erfahrung im Bereich Basteln, Kreativ oder Werken.

          Ansprechperson
          Marianne Neumann (+49 176 87967704) DIY; Jan Block (+49 157 85985507) Werken

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Das Kreativprogramm auf Grundlage von Bibelarbeiten und Camp-Thema vorbereiten.
          - Material einkaufen und vorhandenes Kreativmaterial kennen.
          - Mit anderen Freizeiten Rücksprache über Reste, Bestellungen und Ideen halten.
          - Deko in Abstimmung mit Campstory vorbereiten.

          2. Während der Freizeit
          - Teilnahme an der MATB und Vorstellung bei der ersten AV.
          - Das gesamte Kreativprogramm durchführen.
          - Teilnehmende begleiten, mit ihnen gemeinsam arbeiten und sie anleiten.
          - Kreativmaterial und Kreativraum verantwortungsvoll verwalten.
          - Bei schlechtem Wetter zusätzliche Angebote ermöglichen.
          - Für Hilfe und Unterstützung jederzeit ansprechbar sein.

          3. Nach der Freizeit
          - Kreativinventar und LC-Materialraum ordnen, säubern und übergeben.

          Das Budget
          - Budget: 250 €
          - Kassenbons aufheben.
          - Günstige Webseiten nutzen.
          - Mit anderen Bereichen und Freizeiten abstimmen.
          - Teurere Anschaffungen vorher absprechen.

          Tipps
          - Sprecht mit früheren Kreativmitarbeitern.
          - Probiert Angebote vorher aus.
          - Plant mit To-Do-Listen.
          - Nicht jedes Angebot muss für alle Teilnehmenden gleichzeitig verfügbar sein.
        TEXT,
        responsible_description: <<~TEXT
          Definition
          Der Creativleiter trägt die geistliche und fachliche Verantwortung für das Kreativprogramm und das Kreativteam der Freizeit.

          Erwartung / Haltung
          - Leitungs- und Gestaltungsgabe von Gott.
          - Erfahrung im Bereich Kreativ, Basteln oder Werken.

          Ansprechperson
          Marianne Neumann (+49 176 87967704) DIY; Jan Block (+49 157 85985507) Werken

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung und am BL-Meeting.
          - Das Kreativprogramm detailliert vorbereiten, sodass vor Ort möglichst nichts mehr geplant werden muss.
          - Material einkaufen, den Materialraum kennen und Ideen ausprobieren.
          - Dekoration in Absprache mit Campstory vorbereiten.

          2. Während der Freizeit
          - Teilnahme an der MATB und Vorstellung bei der ersten AV.
          - Das Kreativprogramm leiten und organisieren.
          - Darauf achten, dass Teilnehmende und Mitarbeitende klare Regeln für den Kreativraum kennen.
          - Das Kreativteam führen und die Materialverantwortung tragen.
          - Zusätzliche Angebote für schlechtes Wetter vorbereiten.

          3. Nach der Freizeit
          - Kreativinventar und LC-Materialraum ordnen und die Übergabe an die nächste Freizeit vorbereiten.
        TEXT
      },
      "Küche" => {
        description: <<~TEXT
          Definition
          Küchenmitarbeitende bereiten die Mahlzeiten für das Camp vor und arbeiten unter Lightcamp-, Freizeit- und Küchenleitung.

          Erwartung / Haltung
          - Erfahrung im Bereich Küche und Menüplanung.

          Ansprechperson
          Ailine Johannesmeyer (+49 176 45920114)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Kochen auf der Lightcamp-Schulung.
          - Teilnahme an der Küchenbesprechung zur Menüplanung.
          - Den Küchenchef bei Einkauf und Transport der Lebensmittel unterstützen.

          2. Während der Freizeit
          - Teilnahme an der MATB und Vorstellung bei der ersten AV.
          - Mahlzeiten vor- und nachbereiten.
          - Im Küchenalltag mithelfen und ansprechbar sein.

          3. Nach der Freizeit
          - Die Küche gemeinsam putzen, aufräumen und ordnen.
        TEXT,
        responsible_description: <<~TEXT
          Definition
          Der Küchenchef verantwortet die Menüplanung und leitet die Küchenmitarbeitenden fachlich und geistlich durch die Freizeit.

          Erwartung / Haltung
          - Leitungsgabe von Gott.
          - Erfahrung im Bereich Küche und Menüplanung.

          Ansprechperson
          Ailine Johannesmeyer (+49 176 45920114)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Kochen auf der Lightcamp-Schulung.
          - Das Menü mit den Küchenchefs der anderen Freizeiten planen.
          - Lebensmittel für die Freizeit einkaufen.
          - Bei Bedarf am BL-Meeting teilnehmen.

          2. Während der Freizeit
          - Teilnahme an der MATB und Vorstellung bei der ersten AV.
          - Küchenpersonal in Abläufe, Aufgaben und Tagesplan einführen.
          - Mahlzeiten und Vorräte vorausschauend planen.
          - Küchenmitarbeitende führen, Feedbackgespräche halten und tägliche Meetings leiten.
          - Für Unterstützung jederzeit ansprechbar sein.

          3. Nach der Freizeit
          - Küche in Absprache mit dem Hausmeister putzen, aufräumen und ordnen.

          Das Budget
          - Budget nach Absprache mit dem Lightcamp-Team.
        TEXT
      },
      "Fotograf" => {
        description: <<~TEXT
          Definition
          Der MPR-Mitarbeiter unterstützt das Lightcamp-Programm flexibel mit Foto-, Video- und Multimedia-Angeboten. Er dokumentiert die Freizeit und bereitet Inhalte für Abendveranstaltungen und Nacharbeit auf.

          Erwartung / Haltung
          - Teamfähigkeit und grundlegendes Wissen rund um Multimedia.
          - Selbstständiges und verantwortungsbewusstes Arbeiten.

          Ansprechperson
          Ailine Johannesmeyer (+49 176 4592114)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Ausrüstung organisieren und testen.
          - Projekte wie Videos, Diashows oder Werbespots vorbereiten.

          2. Während der Freizeit
          - Teilnahme an der MATB und Vorstellung bei der ersten AV.
          - Tagesaktivitäten und Highlights dokumentieren.
          - Mehrmals pro Woche Video- oder Diashow-Beiträge für die Abendveranstaltung vorbereiten.
          - Gruppen- und Mitarbeiterfotos erstellen und ausdrucken.
          - Inhalte sortieren, sichern und in Abstimmung mit dem FL veröffentlichen.

          3. Nach der Freizeit
          - Alle Inhalte sauber sortieren, sichern und für die weitere Verwendung vorbereiten.

          Tipps
          - Achtet darauf, dass alle Gruppen und Bereiche im Laufe der Woche sichtbar werden.
          - Prüft Speicherkarten, Akkus und Equipment unbedingt vor der Freizeit.
        TEXT
      },
      "Videograf" => {
        description: <<~TEXT
          Definition
          Der MPR-Mitarbeiter unterstützt das Lightcamp-Programm flexibel mit Foto-, Video- und Multimedia-Angeboten. Er dokumentiert die Freizeit und bereitet Inhalte für Abendveranstaltungen und Nacharbeit auf.

          Erwartung / Haltung
          - Teamfähigkeit und grundlegendes Wissen rund um Multimedia.
          - Selbstständiges und verantwortungsbewusstes Arbeiten.

          Ansprechperson
          Ailine Johannesmeyer (+49 176 4592114)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Ausrüstung organisieren und testen.
          - Projekte wie Videos, Diashows oder Werbespots vorbereiten.

          2. Während der Freizeit
          - Teilnahme an der MATB und Vorstellung bei der ersten AV.
          - Tagesaktivitäten und Highlights dokumentieren.
          - Mehrmals pro Woche Video- oder Diashow-Beiträge für die Abendveranstaltung vorbereiten.
          - Gruppen- und Mitarbeiterfotos erstellen und ausdrucken.
          - Inhalte sortieren, sichern und in Abstimmung mit dem FL veröffentlichen.

          3. Nach der Freizeit
          - Alle Inhalte sauber sortieren, sichern und für die weitere Verwendung vorbereiten.

          Tipps
          - Achtet darauf, dass alle Gruppen und Bereiche im Laufe der Woche sichtbar werden.
          - Prüft Speicherkarten, Akkus und Equipment unbedingt vor der Freizeit.
        TEXT
      },
      "Techniker" => {
        description: <<~TEXT
          Definition
          Der Techniker trägt im Camp flexibel und selbstständig die technische Verantwortung für Aufbauten, Material, Lagerfeuerstellen und praktische Unterstützung.

          Erwartung / Haltung
          - Praktische Fähigkeiten, Kreativität und idealerweise Erfahrung im Umgang mit Werkzeug.

          Ansprechperson
          Jan Block (+49 157 85985507)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Feuerholz, Werkzeuge und benötigtes Material bereitstellen.
          - Mit Programmleitung, Lightcampteam und Campstory klären, ob etwas gebaut werden muss.
          - Lagerfeuerstellen vorbereiten.

          2. Während der Freizeit
          - Teilnahme an der MATB.
          - Beim Anreisetag logistisch unterstützen.
          - Mit dem Hausmeister in Kontakt bleiben.
          - Bei Veranstaltungen präsent sein und bei freier Zeit Beziehungen zu Teilnehmenden bauen.
          - Feuerstellen rechtzeitig vorbereiten.
          - Für Hilfe und Unterstützung jederzeit ansprechbar sein.

          3. Nach der Freizeit
          - Material und Lagerfeuerstellen abbauen und aufräumen.

          Das Budget
          - Budget: 100 €
          - Kassenbons aufheben.
          - Günstige Webseiten oder Kleinanzeigen nutzen.
          - Mit anderen Bereichen und Freizeiten abstimmen.
          - Teurere Anschaffungen vorher absprechen.
        TEXT
      },
      "Prediger" => {
        description: <<~TEXT
          Definition
          Der Prediger ist für die Verkündigung des Wortes Gottes in den Abendpredigten zuständig und soll zugleich als nahbarer Seelsorger und Ansprechpartner für Teilnehmende dienen.

          Erwartung / Haltung
          - Fähigkeit, geistliche Wahrheiten verständlich und lebensnah in die Lebensrealität der Teilnehmenden zu übertragen.

          Ansprechperson
          Peter Voth (0157 8807751)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Predigten thematisch vorbereiten und altersgerecht ausarbeiten.
          - Material für Seelsorge, Gespräche und geistliche Entscheidungen vorbereiten.

          2. Während der Freizeit
          - Für Teilnehmende sichtbar und ansprechbar sein.
          - Abendpredigten im Rahmen des Programms halten.
          - An der MATB teilnehmen und bei Bedarf kurze Andachten übernehmen.
          - Für Hilfe und Unterstützung jederzeit ansprechbar sein.

          Tipps
          - Nutzt Veranschaulichungen, Gegenstände, Flipcharts oder Präsentationen.
          - Sprecht mit früheren Predigern und Teeny-Leitern.
          - Stimmt euch mit Campstory und Programmleitung ab.
        TEXT
      },
      "Krankenpfleger/-in" => {
        description: <<~TEXT
          Definition
          Die Krankenschwester bzw. medizinisch verantwortliche Person trägt im Camp die Verantwortung für medizinische Versorgung, Medikamente und gesundheitliche Notfälle.

          Erwartung / Haltung
          - Ersthelferschein oder medizinische Erfahrung.
          - Ruhiges und verantwortungsbewusstes Handeln in Notfällen.

          Ansprechperson
          Jan Block (+49 157 85985507)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Die medizinische Liste und vorhandene Materialien kontrollieren.
          - Fehlende Medikamente in Abstimmung mit anderen Freizeiten besorgen.

          2. Während der Freizeit
          - Teilnahme an der MATB.
          - Medizinische Versorgung und Medikamentengabe sicherstellen.
          - Im Notfall schnell und kompetent reagieren.
          - Für Hilfe und Unterstützung jederzeit ansprechbar sein.

          3. Nach der Freizeit
          - Materialien kontrollieren und für das nächste Jahr vorbereiten.

          Das Budget
          - Budget: 250 €
          - Kassenbons aufheben.
          - Medikamente möglichst gebündelt mit den anderen Freizeiten einkaufen.
        TEXT
      },
      "Musikverantwortlicher" => {
        description: <<~TEXT
          Definition
          Der Musiker ist für den Gesang in Morgen- und Abendveranstaltungen zuständig und trägt dabei geistliche Verantwortung für die musikalische Ausrichtung.

          Erwartung / Haltung
          - Organisations- und Musikgabe.
          - Erfahrung im Anleiten von Musik.

          Ansprechperson
          Ailine Johannesmeyer (+49 176 45920114)

          Aufgabenbereiche
          1. Vor der Freizeit
          - Teilnahme an der Lightcamp-Schulung.
          - Das Musikprogramm für MV und AV planen.
          - Eine kleine Band aus Mitarbeitenden zusammenstellen.
          - Liedauswahl thematisch und geistlich passend vorbereiten.
          - Instrumente sowie Ton- und Videotechnik organisieren.

          2. Während der Freizeit
          - Teilnahme an der MATB.
          - Proben sinnvoll und realistisch planen.
          - Musikprogramm in Morgen- und Abendveranstaltungen durchführen.
          - Sich mit Technik und Programmleitung abstimmen.
          - Für Hilfe und Unterstützung jederzeit ansprechbar sein.
        TEXT
      }
    }
  end
end
