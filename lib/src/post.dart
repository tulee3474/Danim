class Post {
  String postTitle = ""; // 게시물 제목
  int postNum = 0; // 게시물 넘버
  String postWriter = ""; // 작성자 이름
  List<String> commentList = []; // 댓글 리스트
  List<String> commentWriterList = []; // 댓글 작성자 리스트
  List<String> recommendList = []; // 좋아요 누른 사람 리스트
  int recommendNum = 0; // 좋아요 수
  String postContent = ''; //게시물 내용

  Post(
    this.postTitle,
    this.postNum,
    this.postWriter,
    this.commentList,
    this.commentWriterList,
    this.recommendList,
    this.recommendNum,
    this.postContent,
  );

  Map<String, dynamic> toJson() => {
        'postTitle': postTitle,
        'postNum': postNum,
        'postWriter': postWriter,
        'commentList': commentList,
        'commentWriterList': commentWriterList,
        'recommendList': recommendList,
        'recommendNum': recommendNum,
        'postContent': postContent,
      };
}
