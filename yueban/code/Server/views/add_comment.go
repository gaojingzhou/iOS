package views

import (
	"strconv"

	"../dal/db"

	"github.com/gin-gonic/gin"
)

func AddComment(c *gin.Context) {
	username := c.PostForm("username")
	articleid := c.PostForm("articleid")
	comment := c.PostForm("comment")
	replyuser := c.PostForm("replyuser")
	commentidstr := c.PostForm("commentid")
	replyidstr := c.PostForm("replyid")

	commentid, err := strconv.ParseInt(commentidstr, 10, 64)
	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": "invalid commentid.",
		})
		return
	}
	replyid, err := strconv.ParseInt(replyidstr, 10, 64)
	if err != nil {
		c.JSON(200, gin.H{
			"message":       "error",
			"error_message": "invalid replyid.",
		})
		return
	}

	err1 := db.AddComment(articleid, username, comment, replyuser, int(commentid), int(replyid))

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
