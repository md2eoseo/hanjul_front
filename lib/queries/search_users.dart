String searchUsers = """
  query searchUsers(\$keyword: String!, \$lastId: Int) {
    searchUsers(keyword: \$keyword, lastId: \$lastId) {
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
