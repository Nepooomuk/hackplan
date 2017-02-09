package model

type (
	User struct {
		Id        int
		SureName  string
		FirstName string
		IsAdmin   bool
		Email     string
		Password  string
	}

	Hackathons struct {
		Id         int
		Name       string
		Organistor string
		Projects   []Project
	}

	Project struct {
		Id               int
		Name             string
		Description      string
		UsefullSkulls    map[string]string
		RessourcesNeeded []Ressource
	}

	Ressource struct {
		Id       int
		Name     string
		Quantity int
	}
)