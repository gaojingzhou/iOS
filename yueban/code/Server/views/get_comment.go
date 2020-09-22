package views

import (
	"learnGo/dal/db"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetCommentNum(c *gin.Context) {
	article_id := c.DefaultQuery("article_id", "")
	replyidStr := c.DefaultQuery("reply_id", "0")
	reply_id, err := strconv.ParseInt(replyidStr, 10, 64)
	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": "invalid replyid.",
		})
		return
	}
	num, err := db.GetCommentNum(article_id, int(reply_id))
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
	res["comment_num"] = num
	c.JSON(200, res)
}

func GetComment(c *gin.Context) {
	article_id := c.DefaultQuery("article_id", "")
	offsetStr := c.DefaultQuery("offset", "0")
	replyidStr := c.DefaultQuery("reply_id", "0")
	offset, err := strconv.ParseInt(offsetStr, 10, 64)
	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": "invalid offset.",
		})
		return
	}
	reply_id, err := strconv.ParseInt(replyidStr, 10, 64)
	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": "invalid replyid.",
		})
		return
	}
	comments, err := db.GetComment(article_id, int(offset), int(reply_id))
	if err != nil {
		c.JSON(400, gin.H{
			"message":       "error",
			"error_message": err.Error(),
		})
		return
	}

	res := gin.H{
		"message":       "success",
		"error_message": "",
	}
	res["comments"] = comments
	c.JSON(200, res)
}
