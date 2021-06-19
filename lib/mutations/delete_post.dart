const String deletePost = """
  mutation deletePost(\$id: Int!) {
    deletePost(id: \$id) {
      ok
      error
    }
  }
""";
