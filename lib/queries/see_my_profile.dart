String seeMyProfile = """
query seeMyProfile{
  seeMyProfile{
    ok
    error
    user{
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
