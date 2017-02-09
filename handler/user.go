package handler

import (
	"github.com/kataras/iris"
	"github.com/hackdaysspring2017/hackplan/model"
	"fmt"
)

var userrepo map[int]model.User

func init() {
	userrepo = map[int]model.User{}
}

func LoginHandler(ctx *iris.Context) {

	auth := &model.Auth{}

	if err := ctx.ReadJSON(&auth); err != nil {
		ctx.JSON(500, err.Error())
	} else {
		for _, value := range userrepo {
			if value.Email == auth.Email && value.Password == auth.Password {
				token := &model.Token{Token:"2138123ASDYXCASD"}
				ctx.JSON(200, token)
			} else {
				ctx.JSON(403, "no valid")
			}
		}
	}

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

func UserGetHandler(ctx *iris.Context) {

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

func UserPostHandler(ctx *iris.Context) {

	user := &model.User{}
	if err := ctx.ReadJSON(&user); err != nil {
		ctx.JSON(500, err.Error())
	} else {
		userrepo[user.Id] = *user
	}

	ctx.JSON(200, userrepo)
}

func UserDeleteHandler(ctx *iris.Context) {

	userID, _ := ctx.ParamInt("id")
	delete(userrepo, userID)
	msg := fmt.Sprintf("deleted user with id %v", userID)
	ctx.JSON(200, msg)
}
