package model

type ArticleImg struct {
	UserName  string `gorm:"column:user_name" json:"user_name"`
	ArticleId string `gorm:"column:article_id" json:"article_id"`
	ImgUrl    string `gorm:"column:img_url" json:"img_url"`
}

func (ArticleImg) TableName() string {
	return "article_img"
}
