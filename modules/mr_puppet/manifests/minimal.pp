class minimal {
    $minimal_packages = [ "zsh", "screen", "molly-guard", "htop", "dstat", "fail2ban", 
	"strace", "sudo", "vim-nox", "tig", "unattended-upgrades", "augeas-lenses", "augeas-tools", "openssh-server" ]
    package { $minimal_packages:
        ensure => present,
    }

    # Turn on Unattended upgrades
    file { "10periodic":
        ensure => present,
        path => '/etc/apt/apt.conf.d/10periodic',
        owner => root,
        group => root,
        mode => '0644',
        source => "puppet:///modules/mr_puppet/minimal/10periodic",
        require => Package["unattended-upgrades"],
    }

    augeas { "sshd_config":
        context => "/files/etc/ssh/sshd_config",
        changes => [
            "set PermitRootLogin no",
        ],
        notify => Service["ssh"],
    }
    service { "ssh":
        require => [Augeas["sshd_config"], Package["openssh-server"]],
        enable => true,
        ensure => running,
    }

    augeas { "sudo_group_no_passwd":
        context => "/files/etc/sudoers",
        changes => [
            'set spec[user = "%sudo"]/user %sudo',
            'set spec[user = "%sudo"]/host_group/host ALL',
            'set spec[user = "%sudo"]/host_group/command ALL',
            'set spec[user = "%sudo"]/host_group/command/tag NOPASSWD',
        ],
        require => Package["sudo"],
    }

}
