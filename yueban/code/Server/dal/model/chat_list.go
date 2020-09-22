package model

type ChatList struct {
	UserName string `gorm:"column:user_name"`
	ChatName string `gorm:"column:chat_name"`
	ImgUrl string `gorm:"column:img_url"`
	ChatId int `gorm:"column:chat_id"`
}

func (ChatList) TableName() string {
	return "chatList"
}
