# openResolvChecker

open resolver check tool

Require:
 * Perl
 * Mojolicious
 * nginx

## How to install
    install perlbrew
    apt-get install perlbrew
    perlbrew init
    perlbrew install perl-5.16.3
    perlbrew install-cpanm
    cat ~/perl5/perlbrew/etc/bashrc >> ~/.bashrc
    sourc ~/.bashrc
    perlbrew use perl-5.16.3

install mojolicious and perlmodules
    cpanm install Mojolicious
    cpanm install Net::DNS
    cpanm install IO::Socket::IP

change to your nginx's config
    vi /etc/nginx/nginx.conf
        proxy_set_header Host            $host;
        proxy_set_header X-Real-IP       $remote_addr;
        proxy_set_header X-Remote-Addr   $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        location /check {
          proxy_pass http://127.0.0.1:3000/check;
        }

set web page
    cp index.html /nginx's documentroot/


## How to use

 # restart nginx
    /etc/init.d/nginx restart

 # start application
    morbo myapp.pl

 # access your site
    http://yoursite/index.html 



## Copyright

* Copyright (c) 2015- Ken'ichi SAKAGUCHI
* License
  * Apache License, Version 2.0 (see LICENSE)
