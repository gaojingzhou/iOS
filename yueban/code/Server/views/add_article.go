package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func AddArticles(c *gin.Context) {
	articleid := c.PostForm("articleid")
	authorname := c.PostForm("authorname")
	content := c.PostForm("content")
	err := db.AddArticles(articleid, authorname, content)

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
