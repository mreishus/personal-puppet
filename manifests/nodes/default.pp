node default {
    class { "minimal": }
    class { "tmux": }
    class { "etckeeper": }

    # Firewall
    include ufw
    ufw::allow { "allow-ssh-from-all":
        port => 22,
    }

    prezto_zsh::add_prezto_to_user{ "root":
        user => "root",
        homedir => "/root",
    }

    ########### USERNAME GOES HERE ######
    $default_username = "deploy"
    ########### SET PUBKEY BELOW ########

    user::add_user { "$default_username": 
        groups => "sudo",
    }
    user::add_ssh_key { "$default_username": 
        key => "AAAAB3NzaC1yc2EAAAABJQAAAQBmEZQU/mytQS3R1yHcLZk+hhhjg0/AshX2IU4GuUhSGlz4khK8qhPP2TiR4CoUlHkBZd6s+VWJPAJ6t+0ZPLz5qrKnhDRuhuU0Agt3LAdVWwHMZoJBsD2J3Z0UwBfmuC7ZKypO7/8+6ADkBGdkE0O59n9YqRJTE8qJFvxUcKzBbzGmsZoRBUsoPdRHAREGfR5tggFnhMiKos1MJp9trBOy41GKEzhiSBWGZ7dScJs45QlzLKm/qFMWbQCxbrvVXwehzfGQllSmRBCnvqJZjn3V1/Lq2x5gSHXVhYKimfYjiMc6R9I/D8QRnwaopB0UMzjUSik0t99dXcPRKH3VrFqj",
        type => "ssh-rsa",
        comment => "rsa-key-20130323-mr-home-pw",
    }
}
