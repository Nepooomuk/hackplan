package main

import (
	"github.com/kataras/iris"
)

func main() {
	app := iris.New()

	userApi := app.Party("/user")
	{
		userApi.Get("/user", userHandler)
		userApi.Get("/user/:id", userHandler)
		userApi.Post("/user/:id", userHandler)
		userApi.Put("/user/:id", userHandler)
		userApi.Delete("/user/:id", userHandler)
	}

	hackathonsApi := app.Party("/hackathon")
	{
		hackathonsApi.Get("/hackathon", hackathonsHandler)
		hackathonsApi.Get("/hackathon/:id", hackathonsHandler)
		hackathonsApi.Post("/hackathon/:id", hackathonsHandler)
		hackathonsApi.Put("/hackathon/:id", hackathonsHandler)
		hackathonsApi.Delete("/hackathon/:id", hackathonsHandler)
	}

	projectApi := app.Party("/project")
	{
		projectApi.Get("/project", projectHandler)
		projectApi.Get("/project/:id", projectHandler)
		projectApi.Post("/project/:id", projectHandler)
		projectApi.Put("/project/:id", projectHandler)
		projectApi.Delete("/project/:id", projectHandler)
	}

	ressourceApi := app.Party("/ressource")
	{
		ressourceApi.Get("/ressource", ressourceHandler)
		ressourceApi.Get("/ressource/:id", ressourceHandler)
		ressourceApi.Post("/ressource/:id", ressourceHandler)
		ressourceApi.Put("/ressource/:id", ressourceHandler)
		ressourceApi.Delete("/ressource/:id", ressourceHandler)
	}



	/*app.UseTemplate(html.New()).Directory("./views", ".html")

	app.Get("/", func(ctx *iris.Context) {
		ctx.Render("index.html", nil)
	})*/

	app.Listen(":8080")
}

func userHandler(ctx *iris.Context){
	//lol
}

func hackathonsHandler(ctx *iris.Context){
	//lol
}

func projectHandler(ctx *iris.Context){
	//lol
}

func ressourceHandler(ctx *iris.Context){
	//lol
}