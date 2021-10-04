String updateProfile = """
  mutation updateProfile(\$firstName: String, \$lastName: String, \$username: String, \$bio: String) {
    updateProfile(firstName: \$firstName, lastName: \$lastName, username: \$username, bio: \$bio) {
      ok
      error
    }
  }
""";
