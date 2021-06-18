String createPost = """
  mutation createPost(\$wordId: Int!, \$text: String!) {
    createPost(wordId: \$wordId, text: \$text) {
      ok
      error
    }
  }
""";
