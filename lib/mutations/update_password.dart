String updatePassword = """
  mutation updatePassword(\$oldPassword: String!, \$newPassword: String!) {
    updatePassword(oldPassword: \$oldPassword, newPassword: \$newPassword) {
      ok
      error
    }
  }
""";
