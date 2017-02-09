package main

import (
	"fmt"
	"github.com/hackdaysspring2017/hackplan/model"
	"github.com/kataras/iris"
)

var userrepo = map[int]model.User{}
var hackathonrepo = map[int]model.Hackathons{}
var projectrepo = map[int]model.Project{}
var ressourcerepo = map[int]model.Ressource{}

func main() {
	app := iris.New()

	api := app.Party("/api")
	{
		api.Get("/user", userHandler)
		api.Get("/user/:id", userHandler)
		api.Post("/user/:id", userHandler)
		api.Put("/user/:id", userHandler)
		api.Delete("/user/:id", userHandler)

		api.Post("/login", loginHandler)

		api.Get("/hackathon", hackathonsHandler)
		api.Get("/hackathon/:id", hackathonsHandler)
		api.Post("/hackathon/:id", hackathonsHandler)
		api.Put("/hackathon/:id", hackathonsHandler)
		api.Delete("/hackathon/:id", hackathonsHandler)

		api.Get("/project", projectHandler)
		api.Get("/project/:id", projectHandler)
		api.Post("/project/:id", projectHandler)
		api.Put("/project/:id", projectHandler)
		api.Delete("/project/:id", projectHandler)

		api.Get("/ressource", ressourceHandler)
		api.Get("/ressource/:id", ressourceHandler)
		api.Post("/ressource/:id", ressourceHandler)
		api.Put("/ressource/:id", ressourceHandler)
		api.Delete("/ressource/:id", ressourceHandler)
	}

	app.StaticServe("./views", "/ui")

	/*app.UseTemplate(html.New()).Directory("./views", ".html")

	app.Get("/", func(ctx *iris.Context) {
		ctx.Render("index.html", nil)
	})*/

	app.Listen(":8080")
}

func projectHandler(ctx *iris.Context) {
	if ctx.IsGet() {
		projectID, err := ctx.ParamInt("id")
		if err == nil && projectID != 0 {
			currentproject := projectrepo[projectID]
			ctx.JSON(iris.StatusOK, currentproject)
		} else {
			projects := make([]model.Project, 0)

			for _, value := range projectrepo {
				projects = append(projects, value)
			}

			ctx.JSON(iris.StatusOK, map[string]interface{}{
				"projects": &projects,
			})
		}
	}

	if ctx.IsPost() {
		if ctx.IsPost() {
			project := &model.Project{}
			if err := ctx.ReadJSON(&project); err != nil {
				ctx.JSON(500, err.Error())
			} else {
				projectrepo[project.Id] = *project
			}

			ctx.JSON(200, projectrepo)
		}
	}

	if ctx.IsDelete() {
		if ctx.IsDelete() {
			projectID, _ := ctx.ParamInt("id")
			delete(projectrepo, projectID)
			msg := fmt.Sprintf("deleted hackathon with id %v", projectID)
			ctx.JSON(200, msg)
		}
	}
}

func hackathonsHandler(ctx *iris.Context) {
	if ctx.IsGet() {
		hackathonID, err := ctx.ParamInt("id")
		if err == nil && hackathonID != 0 {
			currenthackathon := hackathonrepo[hackathonID]
			ctx.JSON(iris.StatusOK, currenthackathon)
		} else {
			hackathons := make([]model.Hackathons, 0)

			for _, value := range hackathonrepo {
				hackathons = append(hackathons, value)
			}

			ctx.JSON(iris.StatusOK, map[string]interface{}{
				"hackathons": &hackathons,
			})
		}
	}

	if ctx.IsPost() {
		if ctx.IsPost() {
			hackathon := &model.Hackathons{}
			if err := ctx.ReadJSON(&hackathon); err != nil {
				ctx.JSON(500, err.Error())
			} else {
				hackathonrepo[hackathon.Id] = *hackathon
			}

			ctx.JSON(200, hackathonrepo)
		}
	}

	if ctx.IsDelete() {
		if ctx.IsDelete() {
			hackathonID, _ := ctx.ParamInt("id")
			delete(hackathonrepo, hackathonID)
			msg := fmt.Sprintf("deleted hackathon with id %v", hackathonID)
			ctx.JSON(200, msg)
		}
	}
}

func ressourceHandler(ctx *iris.Context) {
	if ctx.IsGet() {
		ressourceID, err := ctx.ParamInt("id")
		if err == nil && ressourceID != 0 {
			currentressource := ressourcerepo[ressourceID]
			ctx.JSON(iris.StatusOK, currentressource)
		} else {
			ressources := make([]model.Ressource, 0)

			for _, value := range ressourcerepo {
				ressources = append(ressources, value)
			}

			ctx.JSON(iris.StatusOK, map[string]interface{}{
				"ressources": &ressources,
			})
		}
	}

	if ctx.IsPost() {
		ressource := &model.Ressource{}
		if err := ctx.ReadJSON(&ressource); err != nil {
			ctx.JSON(500, err.Error())
		} else {
			ressourcerepo[ressource.Id] = *ressource
		}

		ctx.JSON(200, ressourcerepo)
	}

	if ctx.IsDelete() {
		ressourceID, _ := ctx.ParamInt("id")
		delete(ressourcerepo, ressourceID)
		msg := fmt.Sprintf("deleted user with id %v", ressourceID)
		ctx.JSON(200, msg)
	}

}

func loginHandler(ctx *iris.Context) {
	email := ctx.URLParam("email")
	password := ctx.URLParam("password")
	for _, value := range userrepo {
		if value.Email == email && value.Password == password {
			ctx.JSON(200, "true")
		} else {
			ctx.JSON(403, "false")
		}
	}
}

func userHandler(ctx *iris.Context) {
	if ctx.IsGet() {
		userID, err := ctx.ParamInt("id")
		if err == nil && userID != 0 {
			currentuser := userrepo[userID]
			ctx.JSON(iris.StatusOK, currentuser)
		} else {
			users := make([]model.User, 0)

			for _, value := range userrepo {
				users = append(users, value)
			}

			ctx.JSON(iris.StatusOK, map[string]interface{}{
				"users": &users,
			})
		}

	}

	if ctx.IsPost() {
		user := &model.User{}
		if err := ctx.ReadJSON(&user); err != nil {
			ctx.JSON(500, err.Error())
		} else {
			userrepo[user.Id] = *user
		}

		ctx.JSON(200, userrepo)
	}

	if ctx.IsDelete() {
		userID, _ := ctx.ParamInt("id")
		delete(userrepo, userID)
		msg := fmt.Sprintf("deleted user with id %v", userID)
		ctx.JSON(200, msg)
	}
}
