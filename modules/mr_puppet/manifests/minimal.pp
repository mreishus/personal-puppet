class minimal {
    $minimal_packages = [ "zsh", "screen", "molly-guard", "htop", "dstat", "fail2ban", "strace", "sudo", "vim-nox", "tig", "unattended-upgrades" ]
    package { $minimal_packages:
        ensure => present,
    }
    file { "10periodic":
        ensure => present,
        path => '/etc/apt/apt.conf.d/10periodic',
        owner => root,
        group => root,
        mode => '0644',
        source => "puppet:///modules/mr_puppet/minimal/10periodic",
        require => Package["unattended-upgrades"],
    }
}
