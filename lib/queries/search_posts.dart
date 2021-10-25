String searchPosts = """
  query searchPosts(\$keyword: String!, \$lastId: Int, \$pageSize: Int) {
    searchPosts(keyword: \$keyword, lastId: \$lastId, pageSize: \$pageSize) {
      ok
      error
      posts {
        id
        text
        author {
          id
          username
          avatar
          isMe
          isFollowing
          isFollowers
        }
        isLiked
        likesCount
      }
      lastId
    }
  }
""";
