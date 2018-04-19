#!/usr/bin/env perl
package Net::GnuSocial;
$Net::GnuSocial::VERSION = '4.01010';
use Moose;

extends 'Net::Twitter::Core';
with map "Net::Twitter::Role::$_", qw/Legacy/;

has '+apiurl'    => ( default => 'https://gnusocial.de/api' );
has '+apirealm'  => ( default => 'GnuSocial(.de) API'      );

no Moose;

__PACKAGE__->meta->make_immutable;

package main;
use Modern::Perl '2015';
use utf8::all;
use Mojo::UserAgent;
use Net::GnuSocial;
use DateTime;
use XML::FeedPP;

# Register the account
my $user    = 'dilbertbotinoffiziell';
my $pass    = 'insert your password here';
my $account = Net::GnuSocial->new(username => $user, password => $pass);
# Fetch the content
my $ua      = Mojo::UserAgent->new;
my $tx      = $ua->get('http://dilbert.com/feed');
# Catch some network errors
unless ($tx->success) {
	my $err = $tx->error;
	die "$err->{code} response: $err->{message}" if $err->{code};
	die "Connection error: $err->{message}";
}
my $feed = XML::FeedPP::Atom->new($tx->res->body, utf8_flag => 1);
my $date = DateTime->now->ymd();
my $content;

foreach ($feed->match_item(updated => qr/^$date/)) {
	$content = undef;
	$tx = $ua->get($_->link());
	unless ($tx->success) {
		my $err = $tx->error;
		die "$err->{code} response: $err->{message}" if $err->{code};
		die "Connection error: $err->{message}";
	}
	$content  = $feed->title().' - '.$_->title()."\n";
	$content .= $tx->res->dom->at('img[class~="img-comic"]')->attr('src')."\n";
	$content .= '(praise and worship the original: '.$_->link().' )';
	# Post the result
	$account->update($content);
}

1;
