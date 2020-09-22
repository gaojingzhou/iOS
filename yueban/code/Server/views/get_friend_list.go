package views

import (
	"../dal/db"
	"github.com/gin-gonic/gin"
)

func GetFriendList(c *gin.Context) {
	user_name := c.DefaultQuery("user_name", "")

	friends, num, err := db.GetFriendList(user_name)
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
	res["friend_list"] = friends
	res["friend_num"] = num
	c.JSON(200, res)
}
