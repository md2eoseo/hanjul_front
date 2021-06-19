String seeArchive = """
  query seeArchive(\$lastId: Int) {
    seeArchive(lastId: \$lastId) {
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
