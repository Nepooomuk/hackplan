package main

import (
	"fmt"
	"github.com/hackdaysspring2017/hackplan/model"
	"github.com/kataras/iris"
)

var userrepo = map[int]model.User{}

func main() {
	app := iris.New()

	api := app.Party("/api")
	{
		api.Get("/user", userHandler)
		api.Get("/user/:id", userHandler)
		api.Post("/user/:id", userHandler)
		api.Put("/user/:id", userHandler)
		api.Delete("/user/:id", userHandler)
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

func userHandler(ctx *iris.Context) {
	if ctx.IsGet() {
		userID, _ := ctx.ParamInt("id")
		user := &model.User{Id: userID, FirstName: "robin", SureName: "Schatzi", Email: "sdjjasd", IsAdmin: true, Password: "test"}
		users := make([]model.User, 0)

		users = append(users, *user)

		ctx.JSON(iris.StatusOK, map[string]interface{}{
			"users": &users,
		})

	}

	if ctx.IsPost() {
		user := &model.User{}
		if err := ctx.ReadJSON(&user); err != nil {
			ctx.JSON(500, err.Error())
		}else {
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

func hackathonsHandler(ctx *iris.Context) {
	//lol
}

func projectHandler(ctx *iris.Context) {
	//lol
}

func ressourceHandler(ctx *iris.Context) {
	//lol
}
