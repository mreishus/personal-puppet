class prezto_zsh(
    $user,
    $homedir,
    $z_path = "/usr/bin/zsh",
    $p_repo = "git://github.com/mreishus/prezto.git"
) {

    # Deps likely already defined
    if (!defined(Package["git"])) {
        package { "git":
            ensure => present,
        }
    }
    if (!defined(Package["zsh"])) {
        package { "zsh":
            ensure => present,
        }
    }
    if (!defined(Package["perl"])) {
        package { "perl":
            ensure => present,
        }
    }

    # Change shell
    exec { "chsh -s $z_path $user":
        path => "/bin:/usr/bin",
        unless => "grep -E '^${user}.+:${$z_path}$' /etc/passwd",
        require => Package["zsh"]
    }

    # Clone it
    exec { "clone_prezto_zsh": 
        command => "git clone --recursive $p_repo $homedir/.zprezto",
        creates => "$homedir/.zprezto",
        require => [Package["git"], Package["zsh"], Package["perl"]],
    }

    # Link It
    $files_to_link = ['zlogin', 'zlogout', 'zpreztorc', 'zprofile', 'zshenv', 'zshrc']
    link_files { $files_to_link: 
        homedir => $homedir,
        require => Exec["clone_prezto_zsh"],
    }

    define link_files($homedir) {
        file { "$homedir/.$name":
            ensure => link,
            target => "$homedir/.zprezto/runcoms/$name"
        }
    }
}
