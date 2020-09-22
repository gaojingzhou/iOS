package db

import (
	"errors"

	"../model"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"
)

func UserRegister(user_name, password, phone, email string) error {

	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()
	users := make([]*model.User, 0)
	db.Where("user_name = ?", user_name).Find(&users)

	if len(users) != 0 {
		return errors.New("用户名已存在")
	}

	user := model.User{UserName: user_name, PassWord: password, Phone: phone, Email: email}
	db.Create(&user) //新建用户
	return nil
}

func UserLogIn(user_name, password string) (*model.User, error) {

	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return nil, errors.New("connect to database failed.")
	}
	defer db.Close()

	users := make([]*model.User, 0)

	db.Where("user_name = ?", user_name).Find(&users)

	if len(users) == 0 {
		return nil, errors.New("用户不存在")
	}

	db.Where("user_name = ? AND password = ?", user_name, password).Find(&users)

	if len(users) == 0 {
		return nil, errors.New("用户名和密码不匹配")
	}

	return users[0], nil
}

func GetUserInfo(user_name string) (string, string, error) {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return "", "", errors.New("connect to database failed.")
	}
	defer db.Close()
	info := make([]*model.UserDetail, 0)
	db.Where("user_name = ?", user_name).Find(&info)
	return info[0].Sex, info[0].HeadImg, nil
}

func AddUserInfo(user_name, sex, headImg string) error {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()
	//info := make([]*model.UserDetail, 0)
	if sex == "" && headImg == "" {
		new_info := &model.UserDetail{UserName: user_name, Sex: "", HeadImg: ""}
		db.Create(new_info)
		return nil
	}
	if sex != "" {
		db.Exec("update UserInfo set sex = ? where user_name = ?", sex, user_name)
		return nil
	}
	if headImg != "" {
		db.Exec("update UserInfo set head_img = ? where user_name = ?", headImg, user_name)
		return nil
	}
	return nil
}

func GetLike(user_name, article_id string) (int, bool, error) {

	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return 0, false, errors.New("connect to database failed.")
	}
	defer db.Close()
	is_like := false
	like_num := 0
	likes := make([]*model.Like, 0)
	db.Where("user_name = ? AND article_id = ?", user_name, article_id).Find(&likes)
	if len(likes) != 0 {
		is_like = true
	}
	db.Where("article_id = ?", article_id).Find(&likes)
	like_num = len(likes)

	return like_num, is_like, nil
}

func AddLike(user_name, article_id string) error {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()
	likes := make([]*model.Like, 0)
	if user_name == "" || len(user_name) == 0 {
		return errors.New("Please login first")
	}

	db.Where("user_name = ? AND article_id = ?", user_name, article_id).Find(&likes)
	if len(likes) != 0 {
		//这样写切换账号数据库会清空，未找到原因
		//like := &model.Like{UserName: user_name, ArticleId: article_id}
		//db.Delete(&like)
		db.Where("user_name = ? AND article_id = ?", user_name, article_id).Delete(&model.Like{})
		return nil
	}
	like := &model.Like{UserName: user_name, ArticleId: article_id}
	db.Create(&like) //点赞
	return nil
}

func GetFavorite(user_name, article_id string) ([]*model.Favorite, bool, error) {

	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return nil, false, errors.New("connect to database failed.")
	}
	defer db.Close()
	is_fav := false
	fav := make([]*model.Favorite, 0)
	db.Where("user_name = ? AND article_id = ?", user_name, article_id).Find(&fav)
	if len(fav) != 0 {
		is_fav = true
	}
	db.Where("user_name = ?", user_name).Find(&fav)
	return fav, is_fav, nil
}

func AddFavorite(user_name, article_id string) error {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()
	fav := make([]*model.Favorite, 0)
	if user_name == "" || len(user_name) == 0 {
		return errors.New("Please login first")
	}

	db.Where("user_name = ? AND article_id = ?", user_name, article_id).Find(&fav)
	if len(fav) != 0 {
		db.Where("user_name = ? AND article_id = ?", user_name, article_id).Delete(&model.Favorite{})
		return nil
	}
	new_fav := &model.Favorite{UserName: user_name, ArticleId: article_id}
	db.Create(&new_fav) //点赞
	return nil
}

func AddArticleImg(article_id, user_name, img string) error {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()

	new_img := &model.ArticleImg{UserName: user_name, ArticleId: article_id, ImgUrl: img}
	db.Create(&new_img)
	return nil
}

func GetArticleImg(article_id string) (int, []*model.ArticleImg, error) {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return 0, nil, errors.New("connect to database failed.")
	}
	defer db.Close()
	imgs := make([]*model.ArticleImg, 0)
	db.Where("article_id = ?", article_id).Find(&imgs)
	return len(imgs), imgs, nil
}

func AddComment(article_id, user_name, comment, reply_user string, comment_id, reply_id int) error {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()

	new_comment := &model.Comment{ArticleId: article_id, UserName: user_name, Comment: comment, CommentID: comment_id, ReplyID: reply_id, ReplyUser: reply_user}
	db.Create(&new_comment)
	return nil
}

func GetComment(article_id string, offset, reply_id int) ([]*model.Comment, error) {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return nil, errors.New("connect to database failed.")
	}
	defer db.Close()
	comments := make([]*model.Comment, 0)
	if reply_id == 0 {
		db.Where("article_id = ? AND reply_id = ?", article_id, reply_id).Find(&comments)
	} else {
		db.Where("article_id = ? AND reply_id = ?", article_id, reply_id).Find(&comments)
	}
	return comments, nil
}

func GetCommentNum(article_id string, reply_id int) (int, error) {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return 0, errors.New("connect to database failed.")
	}
	defer db.Close()

	all_comments := make([]*model.Comment, 0)
	db.Where("article_id = ? AND reply_id = ?", article_id, reply_id).Find(&all_comments)
	return len(all_comments), nil
}

func GetArticles(offset int, articleid, username string) ([]*model.Article, int, error) {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return nil, 0, errors.New("connect to database failed.")
	}
	defer db.Close()
	articleList := make([]*model.Article, 0)
	articleList1 := make([]*model.Article, 0)
	if articleid == "" && username == "" {
		db.Select("*").Offset(offset).Find(&articleList)
		//db.Exec("select * from article order by article_id DESC").Find(&articleList)
		db.Select("*").Find(&articleList1)
	} else {
		if username == "" {
			db.Where("article_id = ?", articleid).Find(&articleList)
			db.Where("article_id = ?", articleid).Find(&articleList1)
		} else {
			db.Where("author = ?", username).Find(&articleList)
			db.Where("author = ?", username).Find(&articleList1)
		}
	}
	return articleList, len(articleList1), nil
}

func AddArticles(article_id, author_name, content string) error {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()
	new_article := &model.Article{ArticleId: article_id, Author: author_name, Content: content}
	db.Create(&new_article)
	return nil
}

func GetYueBan(part, point string) ([]*model.YueBan, error) {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return nil, errors.New("connect to database failed.")
	}
	defer db.Close()
	yuebanList := make([]*model.YueBan, 0)
	db.Where("part = ? AND point_name = ?", part, point).Find(&yuebanList)
	return yuebanList, nil
}

func AddYueBan(user_name, content, time, part, point, place string) error {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()
	chatName := place + time
	new_yueban := &model.YueBan{UserName: user_name, Content: content, Time: time, Part: part, PointName: point, Place: place, Chat: chatName}
	db.Create(&new_yueban)
	return nil
}

func GetFriendList(username string) ([]*model.FriendList, int, error) {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return nil, 0, errors.New("connect to database failed.")
	}
	defer db.Close()
	friend_list := make([]*model.FriendList, 0)

	db.Where("user_name = ?", username).Find(&friend_list)

	return friend_list, len(friend_list), nil
}

func AddFriend(username, friendname, sex, img string, friend_id int) error {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()

	new_friend := &model.FriendList{UserName: username, FriendName: friendname, Sex: sex, Img: img, FriendId: friend_id}
	db.Create(&new_friend)
	return nil
}

func GetChatList(username string) ([]*model.ChatList, int, error) {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return nil, 0, errors.New("connect to database failed.")
	}
	defer db.Close()
	chat_list := make([]*model.ChatList, 0)

	db.Where("user_name = ?", username).Find(&chat_list)

	return chat_list, len(chat_list), nil
}

func GetChatRecord(chatname string) ([]*model.ChatRecord, int, error) {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return nil, 0, errors.New("connect to database failed.")
	}
	defer db.Close()
	chat_record := make([]*model.ChatRecord, 0)

	db.Where("chat_name = ?", chatname).Find(&chat_record)

	return chat_record, len(chat_record), nil
}

func AddChatRecord(chatname, record string, record_id int) error {
	db, err := gorm.Open("mysql", "root:37290950a@/userdb?charset=utf8&parseTime=True&loc=Local")
	if err != nil {
		return errors.New("connect to database failed.")
	}
	defer db.Close()

	new_record := &model.ChatRecord{ChatName: chatname, Record: record, RecordId: record_id}
	db.Create(&new_record)
	return nil
}
