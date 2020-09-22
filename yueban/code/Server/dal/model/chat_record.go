package model

type ChatRecord struct {
	ChatName string `gorm:"column:chat_name"`
	Record string `gorm:"column:record"`
	RecordId int `gorm:"column:record_id"`
}

func (ChatRecord) TableName() string {
	return "chatRecord"
}
