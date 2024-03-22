# using Puppet to make changes to our configuration file.
# must be configured to refuse to authenticate using a password
include stdlib

file_line { 'Turn off passwrd authentication':
  ensure => present,
  path   => '/etc/ssh/ssh_config',
  line   => '    PasswordAuthentication no',
  replace => true,
}

file_line { 'identity file':
  ensure => present,
  path   => '/etc/ssh/ssh_config',
  line   => '     IdentityFile ~/.ssh/school',
  replace => true,
}
