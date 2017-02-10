package handler

import (
	"fmt"
	"github.com/hackdaysspring2017/hackplan/model"
	"github.com/kataras/iris"
)

var hackathonrepo map[int]model.Hackathons

func init() {
	hackathonrepo = map[int]model.Hackathons{}
	projects := make([]model.Project, 0)
	hackathonrepo[1] = model.Hackathons{Id: 1, Name: "Rewe Systems Hackathon 2017", Organisator: "Rewe", Projects: projects}
	hackathonrepo[2] = model.Hackathons{Id: 2, Name: "Frankfurt DeutscheBank Hack 2017", Organisator: "DeutscheBank", Projects: projects}
	hackathonrepo[3] = model.Hackathons{Id: 3, Name: "Rewe Digital Hackabend", Organisator: "Rewe", Projects: projects}
	hackathonrepo[4] = model.Hackathons{Id: 4, Name: "Global Around-The-World", Organisator: "IBM", Projects: projects}
}

func HackathonGetHandler(ctx *iris.Context) {
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

func HackathonPostHandler(ctx *iris.Context) {

	hackathon := &model.Hackathons{}
	if err := ctx.ReadJSON(&hackathon); err != nil {
		ctx.JSON(500, err.Error())
	} else {
		hackathonrepo[hackathon.Id] = *hackathon
	}

	ctx.JSON(200, hackathonrepo)

}

func HackathonDeleteHandler(ctx *iris.Context) {

	hackathonID, _ := ctx.ParamInt("id")
	delete(hackathonrepo, hackathonID)
	msg := fmt.Sprintf("deleted hackathon with id %v", hackathonID)
	ctx.JSON(200, msg)
}
