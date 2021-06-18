String seeProfile = """
  query seeProfile(\$username: String!) {
    seeProfile(username: \$username) {
      ok
      error
      user {
        id
        firstName
        lastName
        username
        bio
        avatar
        totalPosts
        totalFollowers
        totalFollowing
        isMe
        isFollowers
        isFollowing
      }
    }
  }
""";
