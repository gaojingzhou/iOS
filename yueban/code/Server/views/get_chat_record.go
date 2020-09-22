package views

import (
	"../dal/db"
	"github.com/gin-gonic/gin"
)

func GetChatRecord(c *gin.Context) {
	user_name := c.DefaultQuery("chat_name", "")

	records, num, err := db.GetChatRecord(user_name)
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
	res["chat_record"] = records
	res["record_num"] = num
	c.JSON(200, res)
}
