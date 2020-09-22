package model

type Favorite struct {
	UserName  string `gorm:"column:user_name" json:"user_name"`
	ArticleId string `gorm:"column:article_id" json:"article_id"`
}

func (Favorite) TableName() string {
	return "favoriteTable"
}
