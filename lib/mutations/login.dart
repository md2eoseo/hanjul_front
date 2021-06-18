String login = """
  mutation login(\$username: String!, \$password: String!) {
    login(username: \$username, password: \$password) {
      ok
      error
      token
    }
  }
""";
