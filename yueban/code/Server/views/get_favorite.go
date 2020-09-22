package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func GetFavorite(c *gin.Context) {
	user_name := c.DefaultQuery("user_name", "")
	article_id := c.DefaultQuery("article_id", "")
	fav, is_fav, err := db.GetFavorite(user_name, article_id)

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
	res["is_favorite"] = is_fav
	res["fav"] = fav
	c.JSON(200, res)
}
