#!/usr/bin/env perl

use Mojolicious::Lite;
use Net::DNS;
use Sys::Syslog;
use IO::Socket::IP;

# share 
our %h_checkedFlag;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

openlog("dnschk", 'ndelay,pid', 'user');
my $res = Net::DNS::Resolver->new;
$res->udp_timeout(1);
$res->tcp_timeout(1);

get '/check' =>sub {
  my $c = shift;
  my $flag = 0;
  #my $rAddr = $c->tx->remote_address;
  my $rAddr = $c->req->headers->header('X-Forwarded-For');

  # When the IP is same, stop 60 sec.
  if(time - $h_checkedFlag{$rAddr} < 60 ){$flag = 3;} 
  $h_checkedFlag{$rAddr} = time;
  if($rAddr =~ /[^.:0-9a-fA-F]+/) {
    $flag  = 2;
    $rAddr = '';
  }
  elsif(!$flag) {
    foreach my $vc (0..1) {
      $res->usevc($vc);
      $res->nameservers($rAddr);
      my $reply = $res->search("m.ROOT-SERVERS.NET");
      if ($reply) {
        foreach my $rr ($reply->answer) {
          next unless $rr->type eq "A";
          my $addr = $rr->address;
          $flag = 1;
          syslog('info', '%s,%s', $rAddr, $addr);
        }
      } else {
        syslog('info', 'query failed %s', $rAddr);
      }
    }
  }
  my $data = { ip => $rAddr, flag => $flag };
  $c->render(json => $data);
};
closelog;

app->start;
