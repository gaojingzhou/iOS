package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func AddArticleImg(c *gin.Context) {
	username := c.PostForm("username")
	articleid := c.PostForm("articleid")
	imgurl := c.PostForm("imgurl")
	err := db.AddArticleImg(articleid, username, imgurl)

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
	c.JSON(200, res)
}
