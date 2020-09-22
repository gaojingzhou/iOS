package views

import (
	"../dal/db"
	"github.com/gin-gonic/gin"
)

func GetChatList(c *gin.Context) {
	user_name := c.DefaultQuery("user_name", "")

	chats, num, err := db.GetChatList(user_name)
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
	res["chat_list"] = chats
	res["chat_num"] = num
	c.JSON(200, res)
}
