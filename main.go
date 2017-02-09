package main

import (
	"github.com/kataras/go-template/html"
	"github.com/kataras/iris"
)

func main() {
	app := iris.New()
	// 6 template engines are supported out-of-the-box:
	//
	// - standard html/template
	// - amber
	// - django
	// - handlebars
	// - pug(jade)
	// - markdown
	//
	// Use the html standard engine for all files inside "./views" folder with extension ".html"
	// Defaults to:
	app.UseTemplate(html.New()).Directory("./views", ".html")

	// http://localhost:6111
	// Method: "GET"
	// Render ./views/index.html
	app.Get("/", func(ctx *iris.Context) {
		ctx.Render("index.html", nil)
	})


	// Start the server at 0.0.0.0:6111
	app.Listen(":8080")
}
