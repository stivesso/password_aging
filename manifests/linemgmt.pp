define password_aging::linemgmt(
  $file,
  $line,
  $pattern
) {
  file_line { "$file_$line":
    path  => $file,
    line  => $line,
    match => $pattern,
  }

}
