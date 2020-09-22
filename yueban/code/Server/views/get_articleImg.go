package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func GetArticleImg(c *gin.Context) {
	article_id := c.DefaultQuery("article_id", "")
	imgnum, imgs, err := db.GetArticleImg(article_id)

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
	res["img_num"] = imgnum
	res["imgs"] = imgs
	c.JSON(200, res)
}
