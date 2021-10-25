String updateProfileImage = """
  mutation updateProfile(\$avatar: Upload) {
    updateProfile(avatar: \$avatar) {
      ok
      error
    }
  }
""";
