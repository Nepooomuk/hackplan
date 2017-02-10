package handler

import (
	"fmt"
	"github.com/hackdaysspring2017/hackplan/model"
	"github.com/kataras/iris"
)

var projectrepo map[int]model.Project

func init() {
	projectrepo = map[int]model.Project{}
	ressourcesneeded := make([]model.Ressource, 0)
	usefullskills := make(map[string]string)
	projectrepo[1] = model.Project{Id: 1, Name: "Hackplan", Description: "Plan Hackdays!", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[2] = model.Project{Id: 2, Name: "App für SWOP-Plätze", Description: "App für Echtzeitdarstellung freier SWOP-Plätze", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[3] = model.Project{Id: 3, Name: "Markt/Artikelfinder", Description: "Markt/Artikelfinder", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[4] = model.Project{Id: 4, Name: "StandBy-Service", Description: "StandBy-Service", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[5] = model.Project{Id: 5, Name: "Warteschlangendetektor", Description: "Warteschlangendetektor!", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[6] = model.Project{Id: 6, Name: "Digitaler Einkaufswagen mit Raspberry Pi", Description: "Digitaler Einkaufswagen mit Raspberry Pi!", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[7] = model.Project{Id: 7, Name: "Selbstlernender Einkaufsassistent", Description: "Selbstlernender Einkaufsassistent!", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[8] = model.Project{Id: 8, Name: "Hardwarescanner App", Description: "Hardwarescanner App!", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[9] = model.Project{Id: 9, Name: "UX-Analyse mit Mouseflow Analytics", Description: "UX-Analyse mit Mouseflow Analytics", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[10] = model.Project{Id: 10, Name: "Digitaler Einkaufswagen mit Raspberry Pi", Description: "Digitaler Einkaufswagen mit Raspberry Pi!", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[12] = model.Project{Id: 12, Name: "Wizard-of-Rewe", Description: "Wizard-of-Rewe!", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[13] = model.Project{Id: 13, Name: "Digitales Raum System (DRS)", Description: "Digitales Raum System (DRS)", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[14] = model.Project{Id: 14, Name: "Ein digitales Sticker-Sammelalbum", Description: "Ein digitales Sticker-Sammelalbum", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[15] = model.Project{Id: 15, Name: "QontRact", Description: "QontRact", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[16] = model.Project{Id: 16, Name: "Wizard-of-Rewe", Description: "Wizard-of-Rewe!", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}
	projectrepo[17] = model.Project{Id: 17, Name: "Parkhausmanagement", Description: "Parkhausmanagement", UsefullSkills: usefullskills, RessourcesNeeded: ressourcesneeded}

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
