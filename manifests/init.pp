#
# Class: sudo
#   Manages sudo configuration
#   Checks sudoers before deploying it, using visudo (requires validate() function)
#
class sudo::common {

   $sudoers_base  = $sudoers_base ? {
      "" => "# /etc/sudoers
#
# This file MUST be edited with the 'visudo' command as root.
#
# See the man page for details on how to write a sudoers file.
#

Defaults        !!env_reset

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL) ALL
",
      default => $sudoers_base
   }

   $sudoers_extra = $sudoers_extra ? {
        ""      => "",
        default => $sudoers_extra
   }

   $sudoers_content = template("sudo/sudoers.erb")

   file { "/etc/sudoers":
      ensure  => present,
      owner   => "root",
      mode    => "600",
      content => validate("$sudoers_content", "/usr/sbin/visudo -c -f ")
   }

   # Replace with validate function to make sure we don't send bad sudoers
   #exec { "check_sudoers":
   #   command     => "/usr/sbin/visudo -c",
   #   refreshonly => true,
   #   subscribe   => File["/etc/sudoers"]
   #}

}




