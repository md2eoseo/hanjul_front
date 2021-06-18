String seeFollowers = """
  query seeFollowers(\$username: String!, \$lastId: Int) {
    seeFollowers(username: \$username, lastId: \$lastId) {
      ok
      error
      followers {
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
