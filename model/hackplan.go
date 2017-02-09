package model

type (
	User struct {
		Id        int    `json:"id"`
		SureName  string `json:"surename"`
		FirstName string `json:"firstname"`
		IsAdmin   bool   `json:"isadmin"`
		Email     string `json:"email"`
		Password  string `json:"password"`
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
