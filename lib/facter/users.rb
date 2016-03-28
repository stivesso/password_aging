#
# users.rb
#
# This fact provides an alphabetic list of users on a Linux system host.
# This is a modified version of that rb file to fit the need of password_aging Puppet Module
# The original version is available at: https://github.com/kwilczynski/facter-facts/blob/master/users.rb
#
#

require 'puppet'

if Facter.value(:kernel) == 'Linux'
  # We store a list of users which are not an essential systems users here ...
  users = []

  #
  # Modern Linux distributions provide "/etc/passwd" in the following format:
  #
  #  root:x:0:0:root:/root:/bin/bash
  #  (...)
  #
  # Above line has the follwing fields separated by the ":" (colon):
  #
  #  <user name>:<password>:<user ID>:<group ID>:<comment>:<home directory>:<command shell>
  #
  # We only really care about "user name" and "user ID" fields.
  #

  #
  # We use "getent" binary first if possible to look-up what users are currently
  # available on system.  This is possibly due to an issue in Puppet "user" type
  # which causes Facter to delay every Puppet run substantially especially when
  # LDAP is in place to provide truth source about users etc ...
  #
  # In the unlikely event in which the "getent" binary is not available we simply
  # fall-back to using Puppet "user" type ...
  #
  if File.exists?('/usr/bin/getent')
    # We work-around an issue in Facter #10278 by forcing locale settings ...
    ENV['LC_ALL'] = 'C'

    #
    # We utilise rely on "cat" for reading values from entries under "/proc".
    # This is due to some problems with IO#read in Ruby and reading content of
    # the "proc" file system that was reported more than once in the past ...
    #
    Facter::Util::Resolution.exec('/usr/bin/getent passwd').each_line do |line|
      # Remove bloat ...
      line.strip!

      # Turn line into a set of tokens ...
      user = line.split(':')

      # Add user to list only if the user is not an essential system user ...
      users << user[0]
    end
  else
    Puppet::Type.type('user').instances.each do |user|
      # Get details about the user from the corresponding instance ...
      instance = user.retrieve

      # Add user to list only if the user is not an essential system user ...
      users << user.name
    end
  end

  Facter.add('users') do
    confine :kernel => :linux
    setcode { users.sort }
  end
end

# vim: set ts=2 sw=2 et :
# encoding: utf-8
