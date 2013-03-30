node /bubble/ {
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
    #### TODO: Fix username/pubkey customization using Hiera + YAML/JSON Data source as
    #### an isolated 'config store'
    #### http://docs.puppetlabs.com/hiera/1/
    #### Requires puppet 3.0!  Puppetlabs is working on a doc example of this, but it
    #### Isn't ready yet.

    user::add_user { "$default_username": 
        groups => "sudo",
    }
    user::add_ssh_key { "$default_username": 
        key => "AAAAB3NzaC1yc2EAAAABJQAAAQBmEZQU/mytQS3R1yHcLZk+hhhjg0/AshX2IU4GuUhSGlz4khK8qhPP2TiR4CoUlHkBZd6s+VWJPAJ6t+0ZPLz5qrKnhDRuhuU0Agt3LAdVWwHMZoJBsD2J3Z0UwBfmuC7ZKypO7/8+6ADkBGdkE0O59n9YqRJTE8qJFvxUcKzBbzGmsZoRBUsoPdRHAREGfR5tggFnhMiKos1MJp9trBOy41GKEzhiSBWGZ7dScJs45QlzLKm/qFMWbQCxbrvVXwehzfGQllSmRBCnvqJZjn3V1/Lq2x5gSHXVhYKimfYjiMc6R9I/D8QRnwaopB0UMzjUSik0t99dXcPRKH3VrFqj",
        type => "ssh-rsa",
        comment => "rsa-key-20130323-mr-home-pw",
    }

    ## ADD NGINX ##

    ufw::allow { "allow-http-from-all":
        port => 80,
    }
    ufw::allow { "allow-https-from-all":
        port => 443,
    }
    class { "nginx": }
    nginx::add_vhost { "example.com": }
}
