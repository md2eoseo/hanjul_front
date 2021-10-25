String searchUsers = """
  query searchUsers(\$keyword: String!, \$lastId: Int, \$pageSize: Int) {
    searchUsers(keyword: \$keyword, lastId: \$lastId, pageSize: \$pageSize) {
      ok
      error
      users {
        id
        username
        avatar
        isMe
        isFollowing
        isFollowers
      }
      lastId
    }
  }
""";
