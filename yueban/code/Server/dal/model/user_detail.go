package model

type UserDetail struct {
	UserName string `gorm:"column:user_name" json:"user_name"`
	Sex      string `gorm:"column:sex" json:"sex"`
	HeadImg  string `gorm:"column:head_img" json:"head_img"`
}

func (UserDetail) TableName() string {
	return "UserInfo"
}
