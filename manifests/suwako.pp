class suwako_puppet::suwako {
	package { 'epel-release': ensure => installed }
	package { 'python36': ensure => present, require => Package["epel-release"] }
	package { 'python-virtualenv': ensure => installed }
	package { 'git': ensure => installed }

	$owner = "suwako"
	group { $owner:
		ensure => present,
	}

	user { $owner:
		ensure  => present,
		gid     => $owner,
		require => Group[ $owner ],
	}
	
	exec { 'get_code':
		require => [ Package["git"], User[$owner] ],
		onlyif  => '/bin/test ! -d /opt/suwako-bot',
		command => "/bin/bash -c 'cd /opt && git clone http://github.com/nuecd/suwako-bot.git && chown $owner:$owner -R /opt/suwako-bot'"
	 }
	
	file { '/etc/systemd/system/multi-user.target.wants/suwako-bot.service':
		require => Exec["get_code"],
		ensure  => link,
		target  => '/opt/suwako-bot/suwako-bot.service',
	}
	
	file { '/opt/suwako-bot/config.txt':
		require => Exec["get_code"],
		ensure  => present,
		owner   => $owner,
		group   => $owner,
		mode    => "0644",
		source  => 'puppet:///modules/suwako_puppet/config.txt',
	}
	
	exec { 'setup_script':
		onlyif  => '/bin/test ! -d /opt/suwako-bot/bin',
		before  => Service["suwako-bot"],
		require => File["/opt/suwako-bot/config.txt"],
		command => "/bin/bash -c 'cd /opt/suwako-bot && ./run.sh -v --setup && chown -R $owner:$owner /opt/suwako-bot'",
	}
	exec { 'systemd_reload': 
		command => '/usr/bin/systemctl daemon-reload', 
		require => File["/etc/systemd/system/multi-user.target.wants/suwako-bot.service"],
		before  => Service["suwako-bot"],
	}

	service { 'suwako-bot':
		require => File["/etc/systemd/system/multi-user.target.wants/suwako-bot.service"],
		ensure  => running,
	}
}
