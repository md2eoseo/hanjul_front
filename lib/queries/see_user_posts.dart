String seeUserPosts = """
  query seeUserPosts(\$authorId: Int!, \$lastId: Int) {
    seeUserPosts(authorId: \$authorId, lastId: \$lastId) {
      ok
      error
      posts {
        id
        text
        likesCount
        isLiked
      }
      lastId
    }
  }
""";
