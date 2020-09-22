package model

type YueBan struct {
	UserName  string `gorm:"column:user_name" json:"user_name"`
	Content   string `gorm:"column:content" json:"content"`
	Time      string `gorm:"column:time" json:"time"`
	Part      string `gorm:"column:part" json:"part"`
	PointName string `gorm:"column:point_name" json:"point_name"`
	Place     string `gorm:"column:place" json:"place"`
	Chat      string `gorm:"column:chat_name" json:"chat_name"`
}

func (YueBan) TableName() string {
	return "yueBanTable"
}
