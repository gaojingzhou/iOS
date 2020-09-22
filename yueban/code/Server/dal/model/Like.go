package model

type Like struct {
	UserName  string `gorm:"column:user_name"`
	ArticleId string `gorm:"column:article_id"`
}

func (Like) TableName() string {
	return "likeTable"
}
