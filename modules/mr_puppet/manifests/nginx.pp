class nginx {
    package { "nginx-full":
        ensure => present
    }
}
