package model

type Comment struct {
	ArticleId string `gorm:"column:article_id" json:"article_id"`
	UserName  string `gorm:"column:user_name" json:"user_name"`
	Comment   string `gorm:"column:comment" json:"comment"`
	ReplyUser string `gorm:"column:reply_user" json:"reply_user"`
	CommentID int    `gorm:"column:comment_id" json:"comment_id"`
	ReplyID   int    `gorm:"column:reply_id" json:"reply_id"`
}

func (Comment) TableName() string {
	return "commentTable"
}
