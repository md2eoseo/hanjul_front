String seeUserPosts = """
  query seeUserPosts(\$username: String!, \$lastId: Int) {
    seeUserPosts(username: \$username, lastId: \$lastId) {
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
