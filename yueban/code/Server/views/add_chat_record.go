package views

import (
	"strconv"

	"../dal/db"

	"github.com/gin-gonic/gin"
)

func AddChatRecord(c *gin.Context) {
	chatname := c.PostForm("chat_name")
	record := c.PostForm("record")
	recordidstr := c.PostForm("record_id")

	recordid, err := strconv.ParseInt(recordidstr, 10, 64)
	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": "invalid friendid.",
		})
		return
	}

	err1 := db.AddChatRecord(chatname, record, int(recordid))

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
