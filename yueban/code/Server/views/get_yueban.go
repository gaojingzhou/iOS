package views

import (
	"../dal/db"

	"github.com/gin-gonic/gin"
)

func GetYueBan(c *gin.Context) {
	part := c.DefaultQuery("part", "")
	point := c.DefaultQuery("point", "")
	yuebanList, err := db.GetYueBan(part, point)

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
	res["list"] = yuebanList
	c.JSON(200, res)
}
