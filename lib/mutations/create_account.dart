String createAccount = """
  mutation createAccount(\$firstName: String!, \$lastName: String!, \$username: String!, \$email: String!, \$password: String!) {
    createAccount(firstName: \$firstName, lastName: \$lastName, username: \$username, email: \$email, password: \$password) {
      ok
      error
      username
    }
  }
""";
