package model

type (

	User struct {
		Name        string `json:"name"`
		Link        string `json:"link"`
		Squad       string `json:"squad"`
		Team        string `json:"team"`
		ActiveGroup string `json:"active_group"`
	}
)
