package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func UserRegister(c *gin.Context) {

	username := c.PostForm("username")
	password := c.PostForm("password")
	phone := c.PostForm("phone")
	email := c.PostForm("email")
	err := db.UserRegister(username, password, phone, email)

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
