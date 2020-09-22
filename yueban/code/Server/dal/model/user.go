package model

type User struct {
	UserName string `gorm:"column:user_name"`
	PassWord string `gorm:"column:password"`
	Phone    string `gorm:"column:phone"`
	Email    string `gorm:"column:email"`
}

func (User) TableName() string {
	return "users"
}
