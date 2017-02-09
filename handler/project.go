package handler

import (
	"github.com/kataras/iris"
	"github.com/hackdaysspring2017/hackplan/model"
	"fmt"
)

var projectrepo map[int]model.Project

func init()  {
	projectrepo = map[int]model.Project{}
	ressourcesneeded := make([]model.Ressource, 0)
	usefullskills := make(map[string]string)
	projectrepo[1] = model.Project{Id:1, Name: "Hackplan", Description: "Plan Hackdays!", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}

}

func ProjectGetHandler(ctx *iris.Context) {
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

func ProjectPostHandler(ctx *iris.Context) {

	project := &model.Project{}
	if err := ctx.ReadJSON(&project); err != nil {
		ctx.JSON(500, err.Error())
	} else {
		projectrepo[project.Id] = *project
	}

	ctx.JSON(200, projectrepo)
}

func ProjectDeleteHandler(ctx *iris.Context) {
	projectID, _ := ctx.ParamInt("id")
	delete(projectrepo, projectID)
	msg := fmt.Sprintf("deleted hackathon with id %v", projectID)
	ctx.JSON(200, msg)
}
