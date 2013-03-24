class prezto_zsh {

    define add_prezto_to_user(
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
        # FIXME - .zprezto belongs to root after this
        exec { "clone_prezto_zsh_$user": 
            command => "git clone --recursive $p_repo $homedir/.zprezto",
            creates => "$homedir/.zprezto",
            require => [Package["git"], Package["zsh"], Package["perl"]],
        }

        # Add symlinks
        file { "$homedir/.zlogin":
            ensure => link,
            target => "$homedir/.zprezto/runcoms/zlogin",
            require => Exec["clone_prezto_zsh_$user"],
        }
        file { "$homedir/.zlogout":
            ensure => link,
            target => "$homedir/.zprezto/runcoms/zlogout",
            require => Exec["clone_prezto_zsh_$user"],
        }
        file { "$homedir/.zpreztorc":
            ensure => link,
            target => "$homedir/.zprezto/runcoms/zpreztorc",
            require => Exec["clone_prezto_zsh_$user"],
        }
        file { "$homedir/.zprofile":
            ensure => link,
            target => "$homedir/.zprezto/runcoms/zprofile",
            require => Exec["clone_prezto_zsh_$user"],
        }
        file { "$homedir/.zshenv":
            ensure => link,
            target => "$homedir/.zprezto/runcoms/zshenv",
            require => Exec["clone_prezto_zsh_$user"],
        }
        file { "$homedir/.zshrc":
            ensure => link,
            target => "$homedir/.zprezto/runcoms/zshrc",
            require => Exec["clone_prezto_zsh_$user"],
        }

        /* doesn't work for multiple users, $name collision
        # Link It
        $files_to_link = ['zlogin', 'zlogout', 'zpreztorc', 'zprofile', 'zshenv', 'zshrc']
        link_files { $files_to_link: 
            homedir => $homedir,
            require => Exec["clone_prezto_zsh_$user"],
        }
        */

    }

    /* doesn't work for multiple users, $name collision
    define link_files($homedir) {
        file { "$homedir/.$name":
            ensure => link,
            target => "$homedir/.zprezto/runcoms/$name"
        }
    }
    */
}
