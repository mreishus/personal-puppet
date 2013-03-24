class nginx {
    package { "nginx-full":
        ensure => present
    }
    group { "www-adm":
        ensure => "present",
    }
    service { "nginx":
        enable => true,
        ensure => running,
        require => Package["nginx-full"],
    }
    file { '/var/www':
        ensure => directory,
        mode => '0775',
        owner => 'root',
        group => 'www-adm',
        require => Group["www-adm"],
    }
    # todo: Redo this w/ virtual user resources
    exec { "root www-adm membership":
        unless => "grep -q 'www-adm\\S*root' /etc/group",
        command => "usermod -aG www-adm root",
        require => Group["www-adm"],
    }
    file { "/var/www/z-default":
        ensure => link,
        target => "/usr/share/nginx/www",
        require => File["/var/www"],
    }

    define add_vhost() {
        $site = $title
        file { "/var/www/$site":
            ensure => directory,
            mode => '0775',
            owner => 'root',
            group => 'www-adm',
            require => [Group["www-adm"], File["/var/www"]],
        }
        file { "/var/www/$site/html":
            ensure => directory,
            mode => '0775',
            owner => 'root',
            group => 'www-adm',
            require => File["/var/www/$site"],
        }
        file { "/etc/nginx/sites-available/$site.conf":
            owner => 'root',
            mode => '0644',
            content => template("mr_puppet/nginx/siteconf.erb"),
            require => Package["nginx-full"],
        }
        file { "/etc/nginx/sites-enabled/$site.conf":
            ensure => link,
            target => "/etc/nginx/sites-available/$site.conf",
            notify => Service["nginx"],
            require => File["/etc/nginx/sites-available/$site.conf"],
        }
    }
}
