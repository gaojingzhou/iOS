package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func AddUserInfo(c *gin.Context) {
	username := c.PostForm("username")
	sex := c.PostForm("sex")
	headImg := c.PostForm("headImg")
	err := db.AddUserInfo(username, sex, headImg)

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
