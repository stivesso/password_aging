# Class: password_aging
# ===========================
#
# Full description of class password_aging here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'password_aging':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
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

  #notify {"User list is ${::users}": }
  #notify {"Local User list is ${::localusers}": }

}
