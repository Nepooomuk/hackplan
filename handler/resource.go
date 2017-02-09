package handler

import (
	"github.com/kataras/iris"
	"github.com/hackdaysspring2017/hackplan/model"
	"fmt"
)

var ressourcerepo map[int]model.Ressource

func init()  {
	ressourcerepo = map[int]model.Ressource{}
}

func RessourceGetHandler(ctx *iris.Context) {
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

func RessourcePostHandler(ctx *iris.Context) {

		ressource := &model.Ressource{}
		if err := ctx.ReadJSON(&ressource); err != nil {
			ctx.JSON(500, err.Error())
		} else {
			ressourcerepo[ressource.Id] = *ressource
		}

		ctx.JSON(200, ressourcerepo)
}
func RessourceDeleteHandler(ctx *iris.Context) {

		ressourceID, _ := ctx.ParamInt("id")
		delete(ressourcerepo, ressourceID)
		msg := fmt.Sprintf("deleted user with id %v", ressourceID)
		ctx.JSON(200, msg)

}
