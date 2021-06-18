String toggleLike = """
  mutation toggleLike(\$postId: Int!) {
    toggleLike(postId: \$postId) {
      ok
      error
      like
    }
  }
""";
