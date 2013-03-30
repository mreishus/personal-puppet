class tmux {

    file { "/usr/local/src": 
        ensure => directory
    }
    package { "libevent-dev":
        ensure => present,
    }
    package { "libncurses5-dev":
        ensure => present,
    }

    exec { "download_untar_tmux":
        cwd => "/usr/local/src",
        command => "wget -q -O - 'http://downloads.sourceforge.net/project/tmux/tmux/tmux-1.8/tmux-1.8.tar.gz?r=http%3A%2F%2Ftmux.sourceforge.net%2F&ts=1364579710&use_mirror=garr' | tar xvz",
        creates => "/usr/local/src/tmux-1.8",
        require => File["/usr/local/src"],
    }
    exec { "configure":
        path => [ "/usr/local/src/tmux-1.8", "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin" ],
        cwd => "/usr/local/src/tmux-1.8",
        command => "./configure",
        require => [Exec["download_untar_tmux"], Package["libevent-dev"], Package["libncurses5-dev"], Package["build-essential"]],
        creates => "/usr/local/src/tmux-1.8/config.h",
    }
    exec { "make":
        cwd => "/usr/local/src/tmux-1.8",
        command => "make && make install",
        require => Exec["configure"],
        creates => "/usr/local/bin/tmux",
    }
}
