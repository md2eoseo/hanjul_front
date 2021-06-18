String seeFollowing = """
  query seeFollowing(\$username: String!, \$lastId: Int) {
    seeFollowing(username: \$username, lastId: \$lastId) {
      ok
      error
      following {
        id
        username
        avatar
        isMe
        isFollowers
        isFollowing
      }
    }
  }
""";
