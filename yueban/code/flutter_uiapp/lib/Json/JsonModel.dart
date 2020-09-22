class ItemModel{
  final String articleId;
  final String authorName;
  final String content;

  const ItemModel(this.articleId, this.authorName,
      this.content);

  @override
  String toString() {
    return 'ItemModel{articleId: $articleId authorName: $authorName, content: $content}';
  }

  ItemModel.fromJson(Map<String, dynamic> json)
      : articleId = json['article_id'],
        authorName = json['author_name'],
        content = json['content'];
}

class ArticleImg{
  final String userName;
  final String articleId;
  final String ImgUrl;

  const ArticleImg(this.userName, this.articleId,
      this.ImgUrl);

  @override
  String toString() {
    return 'ArticleImg{userName: $userName articleId: $articleId, ImgUrl: $ImgUrl}';
  }

  ArticleImg.fromJson(Map<String, dynamic> json)
      : userName = json['user_name'],
        articleId = json['article_id'],
        ImgUrl = json['img_url'];
}

class Favorite{
  final String userName;
  final String articleId;

  const Favorite(this.userName, this.articleId);

  @override
  String toString() {
    return 'ArticleImg{userName: $userName articleId: $articleId}';
  }

  Favorite.fromJson(Map<String, dynamic> json)
      : userName = json['user_name'],
        articleId = json['article_id'];
}


class CommentModel{
  final String articleId;
  final String username;
  final String comment;
  final String replyUser;
  final int commentId;
  final int replyId;

  const CommentModel(this.articleId, this.username, this.comment, this.replyUser, this.commentId,
      this.replyId);

  @override
  String toString() {
    return 'ItemModel{articleId: $articleId, username: $username, comment: $comment,replyUser: $replyUser, commentId: $commentId, replyId: $replyId}';
  }

  CommentModel.fromJson(Map<String, dynamic> json)
      : articleId = json['article_id'],
        username = json['user_name'],
        comment = json['comment'],
        replyUser = json['reply_user'],
        commentId = json['comment_id'],
        replyId = json['reply_id'];
}