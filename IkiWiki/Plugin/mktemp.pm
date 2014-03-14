#!/usr/pkg/bin/perl
# Plugin to create new pages with 'random' names.
package IkiWiki::Plugin::mktemp ;

use warnings ;
use strict ;
use IkiWiki 3.00 ;

use vars qw/
	$template_re
	$template_default
	@template_dict / ;

# TODO: Configure these as 'config' variables.
$template_re = 'X{3,}' ;
$template_default = 'XXXXXX' ;
			# these should be a plugin variables
@template_dict =
	qw{
		0 1 2 3 4 5 6 7 8 9
		A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
		a b c d e f g h i j k l m n o p q r s t u v w x y z } ;

sub _get_template_default
{
	return $template_default ;
}

sub mktemp
{  
	my $template0 = @_ > 0 ? $_[0] : $template_default ;
	my( $template0_start,
			$template0_end,
			$template0_len ) = ( 0, 0, 0 ) ;
	while( $template0 =~ /$template_re/g )
	{
		$template0_start = $-[0] ;
		$template0_end = $+[0] ;
		$template0_len = $template0_end - $template0_start ;
	} ;
	return($template0) if( $template0_len == 0 ) ;
	my $tmp0_prefix = substr( $template0, 0, $template0_start ) ;
	my $tmp0_suffix = substr( $template0, $template0_end ) ;
	my $tmp0 =
		$tmp0_prefix
			. join( '',
				map {$template_dict[rand($#template_dict)];}
				1..$template0_len )
			. $tmp0_suffix ;
	return( $tmp0 ) ;
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
		exists $params{title} ?
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
