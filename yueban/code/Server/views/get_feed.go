package views

import (
	"strconv"

	"../dal/db"

	"github.com/gin-gonic/gin"
)

func GetFeed(c *gin.Context) {
	user_name := c.DefaultQuery("user_name", "")
	article_id := c.DefaultQuery("article_id", "")
	offsetStr := c.DefaultQuery("offset", "0")
	offset, err := strconv.ParseInt(offsetStr, 10, 64)
	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": "invalid offset.",
		})
		return
	}

	res := gin.H{
		"message":       "success",
		"error_message": "",
	}
	items, cnt, err := db.GetArticles(int(offset), article_id, user_name)
	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": err.Error(),
		})
		return
	}
	res["items"] = items
	res["article_num"] = cnt
	c.JSON(200, res)
}
