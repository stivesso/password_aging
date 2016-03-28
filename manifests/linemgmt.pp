# Defined class for file_line resource
define password_aging::linemgmt(
  $file,
  $line,
  $pattern
) {
  file_line { "${file}_${line}":
    path  => $file,
    line  => $line,
    match => $pattern,
  }

}
