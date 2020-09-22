package model

type Article struct {
	ArticleId string `gorm:"column:article_id" json:"article_id"`
	Author    string `gorm:"column:author" json:"author_name"`
	Content   string `gorm:"column:content" json:"content"`
}

func (Article) TableName() string {
	return "article"
}
