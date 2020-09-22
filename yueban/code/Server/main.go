package main

import (
	"./views"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "success",
		})
	})
	r.POST("/register", views.UserRegister)
	r.POST("/login", views.UserLogIn)
	r.POST("/like", views.AddLike)
	r.POST("/article", views.AddArticles)
	r.GET("/article", views.GetFeed)
	r.GET("/like", views.GetLike)
	r.GET("/comment", views.GetComment)
	r.GET("/comment_num", views.GetCommentNum)
	r.POST("/comment", views.AddComment)

	r.GET("/friend_list", views.GetFriendList)
	r.POST("/friend_list", views.AddFriend)
	r.GET("/chat_list", views.GetChatList)
	r.GET("/chat_record", views.GetChatRecord)
	r.POST("/chat_record", views.AddChatRecord)

	r.POST("/favorite", views.AddFavorite)
	r.GET("/favorite", views.GetFavorite)

	r.POST("/article/img", views.AddArticleImg)
	r.GET("/article/img", views.GetArticleImg)

	r.POST("/userInfo", views.AddUserInfo)
	r.GET("/userInfo", views.GetUserInfo)
	r.POST("/yueban", views.AddYueBan)
	r.GET("/yueban", views.GetYueBan)
	r.Run(":8081")
}
