#!/usr/pkg/bin/perl
# Plugin to create new pages with 'random' names.
package IkiWiki::Plugin::mktemp ;

use warnings ;
use strict ;
use IkiWiki 3.00 ;

my $template_re = 'X+$' ;
my $template_sep = '' ;
my $template_default = 'XXXXXX' ;
			# these should be a plugin variables
my @template_dict = qw{ 0 1 2 3 4 5 6 7 8 9
		A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
		a b c d e f g h i j k l m n o p q r s t u v w x y z } ;

sub mktemp
{  
	my $template = @_ > 0 ? $_[0] : $template_default ;
	my @template = split( /($template_re)/, $template ) ;
	my @temp ;
	foreach( @template )
	{
		/$template_re/ && do {
			push( @temp,
					map {$template_dict[rand($#template_dict)];}
							1..length($_) ) ;
			next ;
		} ;
		push( @temp, $_ ) ;
	} ;
	return( join($template_sep,@temp) ) ;
} ;

sub import
{
	hook( type => "getsetup",
			id => "mktemp",
			call => \&getsetup ) ;
	hook( type => "preprocess",
			id => "mktemp",
			call => \&preprocess ) ;
} ;

sub getsetup()
{
	return(
			plugin => {
					safe => 1,
					rebuild => undef,
					section => "widget",
					},
			) ;
} ;

sub preprocess( @ )
{
	my %params = @_ ;
	my @page ;
	push( @page, $params{rootpage} )
		if( exists $params{rootpage} ) ;
	my $title =
		exists params{title} ?
			$params{title} :
			"new page" ;
	my $template =
		exists $params{template} ?
			$params{template} :
			$template_default ;
	my $name = mktemp( $template ) ;
	if( $? )
	{
		error gettext( "mktemp failed" ) ;
	} else {
		push( @page, $name ) ;
		return
			"[[$title|" +
				join('/',@page) +
				']]' ;
	} ;
} ;

1 ;
