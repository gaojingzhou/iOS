package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func GetLike(c *gin.Context) {
	user_name := c.DefaultQuery("user_name", "")
	article_id := c.DefaultQuery("article_id", "")
	num, is_like, err := db.GetLike(user_name, article_id)

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
	res["like_num"] = num
	res["is_like"] = is_like
	c.JSON(200, res)
}
