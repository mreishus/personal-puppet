class nginx {
    package { "nginx-full":
        ensure => present
    }
    service { "nginx":
        enable => true,
        ensure => running,
        require => Package["nginx-full"],
    }
}
