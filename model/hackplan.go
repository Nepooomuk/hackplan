package model

type (
	User struct {
		id        int
		sureName  string
		firstName string
		isAdmin   bool
		email     string
		password  string
	}

	Hackathons struct {
		id         int
		name       string
		organistor string
		projects   []Project
	}

	Project struct {
		id               int
		name             string
		description      string
		usefullSkulls    map[string]string
		ressourcesNeeded []Ressource
	}

	Ressource struct {
		id       int
		name     string
		quantity int
	}
)