class etckeeper {
    package { "etckeeper":
        ensure => present
    }
    file { '/etc/etckeeper':
        ensure => directory,
        mode => '0755',
    }
    file { 'etckeeper.conf':
        ensure => present,
        path => '/etc/etckeeper/etckeeper.conf',
        owner => root,
        group => root,
        mode => '0644',
        source => "puppet:///modules/mr_puppet/etckeeper/etckeeper.conf",
        require => [ Package["etckeeper"], File["/etc/etckeeper"] ],
    }
    exec { 'etckeeper-init': 
        command => 'etckeeper init',
        cwd => '/etc',
        creates => '/etc/.git',
        require => [ Package["etckeeper"], File["etckeeper.conf"] ],
    }
}
