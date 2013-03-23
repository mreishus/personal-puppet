class user {
    define add_user($groups = []) {
        $username = $title
        group { $username:
            ensure => "present",
        }
        user { $username:
            gid => $username,
            groups => $groups,
            ensure => "present",
            managehome => true,
            require => Group["$username"],
        }

        prezto_zsh::add_prezto_to_user{ "$username":
            user => "$username",
            homedir => "/home/$username",
            require => User["$username"],
        }

        file { "/home/$username/.ssh":
            ensure  => directory,
            owner   => $username,
            group   => $username,
            mode    => 700,
            require => User["$username"],
        }
        file { "/home/$username/.ssh/authorized_keys":
            ensure  => present,
            owner   => $username,
            group   => $username,
            mode    => 600,
            require => File["/home/$username/.ssh"]
        }
    }
    define add_ssh_key( $key, $type, $comment="${title}_${key}" ) {
        $username = $title
        ssh_authorized_key { "$comment":
            ensure  => present,
            key     => $key,
            type    => $type,
            user    => $username,
            require => File["/home/$username/.ssh/authorized_keys"]
        }
    }

}
