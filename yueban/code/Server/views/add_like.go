package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func AddLike(c *gin.Context) {
	username := c.PostForm("username")
	articleid := c.PostForm("articleid")

	err := db.AddLike(username, articleid)

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
