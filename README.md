# password_aging

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with password_aging](#setup)
    * [What password_aging affects](#what-password_aging-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [TODO](#TODO)
9. [Contributors](#Contributors)

## Overview

The main aim of this module is to manage Password Aging parameters for both existing and future users. The main parameters that are currently managed under this module are:

** pass_max_days         : Maximum number of days a password may be used (default: 99999 days)  
** pass_min_days         : Minimum number of days allowed between password changes (default: 0 day)  
** pass_min_len          : Minimum Lenght of a password (default: 5 character)  
** pass_warn_age         : Password Warning Period before Expritation (default: 7 days)  
** params_file           : the parameters file (default on Linux : /etc/login.defs)  
** manage_existing_user  : Whether or not there is a list of Existing Users which needs these settings (especially max/min days)  
** users_to_manage       : If there are some existing Users to manage, Lists those users in an array  

## Module Description

The module mainly configures systems files that are needed for password aging. It also relies on Puppet User resource to affect existing Users.

## Setup

From Puppet Forge,
```sh
puppet module install stivesso-password_aging
```

From Github,
```sh
git clone https://github.com/stivesso/password_aging
```

### What password_aging affects

 - /etc/login.defs
 - /etc/shadow

### Setup Requirements

Currently require: 
- puppetlabs/stdlib
- pluginsync = true (on Puppet Configuration)


## Usage

To accept default class parameters(default values for password aging are specified above, added to that, we have manage_existing_user which by default is set to false):
```sh
include password_aging
```

It is to note that PASS_MAX_DAYS, PASS_MIN_DAYS and PASS_WARN_AGE as defined above are only used at the time of account creation. Changes to these settings won't affect existing accounts. So If some Existing Accounts need to be aligned to a new defined policy, then there is a need to set manage_existing_user to true and define an array with these existing Users (as seen in the next example below) 

With more details (while modifying the settings for existing oracle, root and user2):
```sh
class  { password_aging:
   pass_max_days         => "90", 
   pass_min_days         => "4", 
   pass_min_len          => "8", 
   pass_warn_age         => "7", 
   manage_existing_user  => true,
   users_to_manage       => ["oracle","root","user2"],
}
```

The module also supports (and encourages) configuration through hiera. Below is an example of such configuration:

```yaml
---
password_aging::pass_max_days: "180"
password_aging::pass_min_days: "28"
password_aging::pass_min_len: "8"
password_aging::pass_warn_age: "7"
password_aging::manage_existing_user: true
password_aging::users_to_manage:
  - "oracle"
  - "root"
```


## Reference

The main used class is password_aging with the parameters described above,

## Limitations

Have been tested on RHEL-Like Distribution only (RHEL,CENTOS,FEDORA,ORACLE LINUX)

## Development

I happily accept bug reports and pull requests via github,  
https://github.com/stivesso/password_aging

Procedure for the Pull Request (PR):  
- Fork password_aging Repository
- Create a topic branch against the dev branch:  
git checkout develop; git checkout -b my_branch
- Push to your branch git push origin my_branch
- Create a Pull Request from your branch against the develop branch

## TODO

- Add Others Unix (Solaris,AIX,HP-UX) Support

## Contributors

- The module is written and being maintained by: stivesso (https://github.com/stivesso) 
- The user custom facts are based on the excellent facter-fact repository (https://github.com/kwilczynski/facter-facts) written by kwilczynski
