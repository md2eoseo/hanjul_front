String seeDayFeed = """
  query seeDayFeed(\$date: String!, \$lastId: Int) {
    seeDayFeed(date: \$date, lastId: \$lastId) {
      ok
      error
      posts {
        id
        text
        author{
          id
          username
          avatar
        }
        authorId
        likesCount
        isLiked
      }
      lastId
    }
  }
""";
