# Define a file resource to replace the faulty line in wp-settings.php
file { '/var/www/html/wp-settings.php':
  ensure  => file,
  content => file('/var/www/html/wp-settings.php').content.gsub('class-wp-locale.phpp', 'class-wp-locale.php'),
  require => Exec['strace_wp_fix'],
}

# Define an exec resource to restart Apache after fixing the file
exec { 'restart_apache':
  command     => '/bin/systemctl restart apache2',
  path        => '/usr/bin:/usr/sbin:/bin',
  refreshonly => true,
  subscribe   => File['/var/www/html/wp-settings.php'],
}

# Define an exec resource to attach strace to Apache process and look for 500 error
exec { 'strace_wp_fix':
  command     => 'strace -p $(pgrep apache2) -f -e trace=open,write,connect,accept',
  path        => '/usr/bin:/usr/sbin:/bin',
  refreshonly => true,
}
