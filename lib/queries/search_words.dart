String searchWords = """
query searchWords(\$date: String){
  searchWords(date: \$date) {
      ok
      error
      words {
        id
        word
        variation
        meaning
        date
      }
    }
}
""";
