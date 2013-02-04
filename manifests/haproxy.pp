# Used to create required db entries for HAproxy health monitoring

class galera::haproxy(
  $mysql_user     	= $galera::params::mysql_user,
  $mysql_password 	= $galera::params::mysql_password,
  $haproxy_user		= 'haproxy',
) 

{
  exec { "haproxy-monitor" :
        command     => "/usr/bin/mysql -u${mysql_user} -p${mysql_password} -e \"USE mysql; INSERT INTO user (Host,User) values ('%','${haproxy_user}'); FLUSH PRIVILEGES;\"",
        path        => '/usr/bin:/usr/sbin:/bin:/sbin',
	subscribe   => Service['mysql-galera'],
	refreshonly => true,  
        unless      => "/usr/bin/mysql -u${mysql_user} -p${mysql_password} -e \"USE mysql; SELECT User FROM user WHERE User = 'haproxy';\"",
    }
}
