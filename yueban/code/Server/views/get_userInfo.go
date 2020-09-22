package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func GetUserInfo(c *gin.Context) {
	user_name := c.DefaultQuery("user_name", "")
	sex, headImg, err := db.GetUserInfo(user_name)

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
	res["sex"] = sex
	res["img"] = headImg
	c.JSON(200, res)
}
