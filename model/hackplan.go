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
		Id          int       `json:"id"`
		Name        string    `json:"name"`
		Organisator string    `json:"organisator"`
		Projects    []Project `json:"projects"`
	}

	Project struct {
		Id               int               `json:"id"`
		Name             string            `json:"name"`
		Description      string            `json:"description"`
		UsefullSkulls    map[string]string `json:"usefullskulls"`
		RessourcesNeeded []Ressource       `json:"ressourcesneeded"`
	}

	Ressource struct {
		Id       int    `json:"id"`
		Name     string `json:"name"`
		Quantity int    `json:"quantity"`
	}
)
