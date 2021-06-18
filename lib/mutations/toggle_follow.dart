String toggleFollow = """
  mutation toggleFollow(\$username: String!) {
    toggleFollow(username: \$username) {
      ok
      error
      follow
    }
  }
""";
