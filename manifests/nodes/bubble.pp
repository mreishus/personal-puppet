node /bubble/ {
    class { "nginx": }
    nginx::add_vhost { "example.com": }
}
