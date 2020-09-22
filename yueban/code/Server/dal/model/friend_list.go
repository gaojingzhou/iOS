package model

type FriendList struct {
	UserName string `gorm:"column:user_name"`
	FriendName string `gorm:"column:friend_name"`
	Sex string `gorm:"column:sex"`
	Img string `gorm:"column:img"`
	FriendId int `gorm:"column:friend_id"`
}

func (FriendList) TableName() string {
	return "friendList"
}