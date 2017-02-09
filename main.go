package main

import (
	"github.com/kataras/iris"
	"github.com/hackdaysspring2017/hackplan/handler"
)

func main() {
	app := iris.New()

	login := app.Party("/api/login")
	{

		login.Post("/")
	}

	api := app.Party("/api")
	{
		api.Get("/user", handler.UserGetHandler)
		api.Get("/user/:id", handler.UserGetHandler)
		api.Post("/user/:id", handler.UserPostHandler)
		api.Delete("/user/:id", handler.UserDeleteHandler)

		api.Post("/login", handler.LoginHandler)

		api.Get("/hackathon", handler.HackathonGetHandler)
		api.Get("/hackathon/:id", handler.HackathonGetHandler)
		api.Post("/hackathon/:id", handler.HackathonPostHandler)
		api.Delete("/hackathon/:id", handler.HackathonDeleteHandler)

		api.Get("/project", handler.ProjectGetHandler)
		api.Get("/project/:id", handler.ProjectGetHandler)
		api.Post("/project/:id", handler.ProjectPostHandler)
		api.Delete("/project/:id", handler.ProjectDeleteHandler)

		api.Get("/ressource", handler.RessourceGetHandler)
		api.Get("/ressource/:id", handler.RessourceGetHandler)
		api.Post("/ressource/:id", handler.RessourcePostHandler)
		api.Delete("/ressource/:id", handler.RessourceDeleteHandler)
	}

	app.StaticServe("./views", "/ui")

	/*app.UseTemplate(html.New()).Directory("./views", ".html")

	app.Get("/", func(ctx *iris.Context) {
		ctx.Render("index.html", nil)
	})*/

	app.Listen(":8080")
}
