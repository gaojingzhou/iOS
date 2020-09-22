package views

import (
	"../dal/db"
	"github.com/gin-gonic/gin"
)

func AddYueBan(c *gin.Context) {
	username := c.PostForm("username")
	content := c.PostForm("content")
	time := c.PostForm("time")
	part := c.PostForm("part")
	point := c.PostForm("point")
	place := c.PostForm("place")

	err := db.AddYueBan(username, content, time, part, point, place)

	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": err.Error(),
		})
		return
	}

	res := gin.H{
		"message":       "success",
		"error_message": "",
	}
	c.JSON(200, res)
}
