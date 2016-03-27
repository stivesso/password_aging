# password_aging

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with password_aging](#setup)
    * [What password_aging affects](#what-password_aging-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with password_aging](#beginning-with-password_aging)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The main aim of this module is to manage Password Aging parameters for both existing and future users. The main parameters that are currently managed under this module are:

PASS_MAX_DAYS:   Maximum number of days a password may be used (default: 99999 days)
PASS_MIN_DAYS:   Minimum number of days allowed between password changes (default: 0 day)
PASS_MIN_LEN:    Minimum Lenght of a password (5 days)
PASS_WARN_AGE:   Password Warning Period before Expritation (7 days)


## Module Description

The module mainly configures systems files that are used to set the needed Settings.
It also makes use of Systems commands to affect existing Users behavior.


## Setup

For now a simple: git clone https://github.com/stivesso/puppet-accounts.git
Once available on Forge; puppet module install stivesso-password_aging

### What password_aging affects

** /etc/shadow
** /etc/login.defs

### Setup Requirements **OPTIONAL**

Currently requires the puppetlabs/stdlib module.

### Beginning with password_aging

See https://github.com/stivesso/password_aging

## Usage

Simplest form:
include password_aging

With more details:

# Include Password Aging
class  { password_aging:
   pass_max_days         => "90", 
   pass_min_days         => "4", 
   pass_min_len          => "8", 
   pass_warn_age         => "7", 
   manage_existing_user  => true,
   users_to_manage       => ["oracle","root","user2"],
}


## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Have been tested on RHEL-Like Distribution only (RHEL,CENTOS,FEDORA,ORACLE LINUX)

## Development

Any contributions to enhance the modules modules are welcome
https://github.com/stivesso/password_aging
