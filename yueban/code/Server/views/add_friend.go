package views

import (
	"strconv"

	"../dal/db"

	"github.com/gin-gonic/gin"
)

func AddFriend(c *gin.Context) {
	username := c.PostForm("user_name")
	friendname := c.PostForm("friend_name")
	sex := c.PostForm("sex")
	img := c.PostForm("img")
	friendidstr := c.PostForm("friend_id")

	friendid, err := strconv.ParseInt(friendidstr, 10, 64)
	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": "invalid friendid.",
		})
		return
	}

	err1 := db.AddFriend(username, friendname, sex, img, int(friendid))

	if err1 != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": err1.Error(),
		})
		return
	}

	res := gin.H{
		"message":       "success",
		"error_message": "",
	}
	c.JSON(200, res)
}
