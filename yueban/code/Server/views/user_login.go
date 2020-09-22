package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func UserLogIn(c *gin.Context) {

	username := c.PostForm("username")
	password := c.PostForm("password")
	user, err := db.UserLogIn(username, password)

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
	res["username"] = user.UserName
	res["email"] = user.Email
	res["phone"] = user.Phone
	c.JSON(200, res)
}
