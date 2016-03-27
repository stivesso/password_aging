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
  $pass_max_days      = $password_aging::params::pass_max_days, 
  $pass_min_days      = $password_aging::params::pass_min_days,
  $pass_min_len       = $password_aging::params::pass_min_len, 
  $pass_warn_age      = $password_aging::params::pass_warn_age,
  $params_file        = $password_aging::params::params_file,
) inherits password_aging::params {

  $params_mod     = [$pass_max_days,$pass_min_days,$pass_min_len,$pass_warn_age]
  $params_pattern = ["PASS_MAX_DAYS","PASS_MIN_DAYS","PASS_MIN_LEN","PASS_WARN_AGE"]


  each($params_mod) | $index, $value | {
    password_aging::linemgmt { "$params_pattern[$index]" :
      file    => $params_file,
      line    => join([$params_pattern[$index],$params_mod[$index]], "\t"),
      pattern => join(["^",$params_pattern[$index]], ""),
    }
  }

}
