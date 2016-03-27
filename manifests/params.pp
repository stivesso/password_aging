class password_aging::params {


  $users_to_manage          = []
  $manage_existing_user     = false


  case $::kernel {
    'linux' : {
      $pass_max_days        = "99999"
      $pass_min_days        = "0"
      $pass_min_len         = "5" 
      $pass_warn_age        = "7"
      $params_file          = "/etc/login.defs"
    }
    # if we are not on a supported os, do not do anything.
    default: { }
  }

}
