# hackplan


Gruppen

1. Verwaltung / Organisation :

- Anlegen von Hackterminen
- Verwaltung von Angemeldeten Nutzern
- Projekte verwalten
- Resource verwalten

2. User :

- Anmelden
- Abmelden
- Profilpflegen
- Zusagen / Absagen
- Projekt einreichen
- Projekt beitretten


typen:

user:
	 id userid
	 string surename
	 string fristname
	 boolean isadmin
	 string email
	 string password

hackathons:
		id hackid
		string name
		string organisator
		array[project] projects

project:
	  id projectid
	  string name
	  string description
	  map[string][string] usefullSkills
	  array[resource] resourcesNeeded

resource:
	  id resourceId
	  string name
	  int quantity


Startseite -> Login, Übersicht der Hackathons,