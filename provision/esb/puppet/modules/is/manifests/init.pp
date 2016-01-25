class is{
  file { '/tmp/wso2is-5.1.0.zip':
    source => '/home/vagrant/wso2is-5.1.0.zip',
  }

  file { '/opt/wso2is-5.1.0':
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => 0644,
  }

  exec { 'Extract WSO2 Identity Server':
    command => '/usr/bin/unzip /tmp/wso2is-5.1.0.zip',
    cwd     => '/opt',
    creates => '/opt/wso2is-5.1.0/bin/wso2server.sh',
    user    => 'vagrant',
    group   => 'vagrant',
    require => File['/tmp/wso2is-5.1.0.zip', '/opt/wso2is-5.1.0'],
    timeout => 0,
  }->
  file { '/etc/init.d/wso2is':
    owner  => root,
    group  => root,
    mode   => 755,
    source => '/vagrant/provision/esb/puppet/modules/is/files/wso2is',
  }->
  service { 'wso2is':
    ensure => true,
    enable => true,
  }

  file { '/opt/wso2is-5.1.0/repository/conf/carbon.xml':
    source  => '/vagrant/provision/esb/puppet/modules/is/files/carbon.xml',
    require => Exec['Extract WSO2 Identity Server'],
    notify  => Service['wso2is'],
  }

}
