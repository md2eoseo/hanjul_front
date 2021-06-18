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
        likesCount
        isLiked
      }
      lastId
    }
  }
""";
