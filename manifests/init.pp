# Class: password_aging
# ===========================
#
# The main aim of this module is to manage Password Aging parameters for both existing and future users.
#
# Parameters
# ----------
#
# Document parameters here.
#
# $pass_max_days         : Maximum number of days a password may be used (default: 99999 days)
# $pass_min_days         : Minimum number of days allowed between password changes (default: 0 day)
# $pass_min_len          : Minimum Lenght of a password (default: 5 chars)
# $pass_warn_age         : Password Warning Period before Expritation (7 days)
# $params_file           : the parameters file (default Linux : /etc/login.defs)
# $manage_existing_user  : Whether or not there is a list of Existing Users which needs these settings (especially max/min)
# $users_to_manage       : If there are some existing Users to manage, Lists those users in an array
#
# Examples
# --------
#
# class  { password_aging:
#   pass_max_days         => "90", 
#   pass_min_days         => "4", 
#   pass_min_len          => "8", 
#   pass_warn_age         => "7", 
#   manage_existing_user  => true,
#   users_to_manage       => ["oracle","root","user2"],
#}
#
# Authors
# -------
#
# Author Name Steve ESSO<stivesso@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Steve ESSO, unless otherwise noted.
#
class password_aging (
  $pass_max_days         = $password_aging::params::pass_max_days, 
  $pass_min_days         = $password_aging::params::pass_min_days,
  $pass_min_len          = $password_aging::params::pass_min_len, 
  $pass_warn_age         = $password_aging::params::pass_warn_age,
  $params_file           = $password_aging::params::params_file,
  $manage_existing_user  = $password_aging::params::manage_existing_user,
  $users_to_manage       = $password_aging::params::users_to_manage,
) inherits password_aging::params {

  validate_integer($pass_max_days)
  validate_integer($pass_min_days)
  validate_integer($pass_min_len)
  validate_integer($pass_warn_age)
  validate_absolute_path($params_file)
  validate_bool($manage_existing_user)
  validate_array($users_to_manage)


  $params_mod     = [$pass_max_days,$pass_min_days,$pass_min_len,$pass_warn_age]
  $params_pattern = ["PASS_MAX_DAYS","PASS_MIN_DAYS","PASS_MIN_LEN","PASS_WARN_AGE"]


  each($params_mod) | $index, $value | {
    password_aging::linemgmt { "$params_pattern[$index]" :
      file    => $params_file,
      line    => join([$params_pattern[$index],$params_mod[$index]], "\t"),
      pattern => join(["^",$params_pattern[$index]], ""),
    }
  }

  if $manage_existing_user == true {
    each($users_to_manage) | $index_user, $value_user | {
      if ($value_user in $::users) {
        user { $value_user:
          password_max_age => $pass_max_days,
          password_min_age => $pass_min_days,
        } 
      }
    }
  }

}
