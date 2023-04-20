String titleCase(String text) {
  return text.split(" ").map((String word) {
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(" ");
}

String removeDashes(String title) {
  return title.replaceAll("-", " ");
}

String clipTitle(String title) {
  final words = title.split(" ");
  // Display only 6 words max
  if (words.length > 6) {
    return "${words.take(6).join(" ")}...";
  } else {
    return title;
  }
}
