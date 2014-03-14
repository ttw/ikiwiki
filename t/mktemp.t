use warnings ;
use strict ;
use Test::More
		tests => 11 ;

BEGIN { use_ok('IkiWiki::Plugin::mktemp'); }

# Remove 'X' from 'template_dict' for validation of results
@IkiWiki::Plugin::mktemp::template_dict =
	grep
		{$_ ne "X";}
		@IkiWiki::Plugin::mktemp::template_dict ;

# Default template
like( IkiWiki::Plugin::mktemp::mktemp(),
	qr/^[^X]{6}$/,
	'Default template: "'
		.IkiWiki::Plugin::mktemp::_get_template_default()
		.'"' ) ;

# basic, with template
like( IkiWiki::Plugin::mktemp::mktemp("XXX"),
	qr/^[^X]{3}$/,
	'Short template: "XXX"' ) ;

# invalid template
is( IkiWiki::Plugin::mktemp::mktemp("XX"),
	"XX",
	'Non-template: "XX"' ) ;

# prefix template
like( IkiWiki::Plugin::mktemp::mktemp("XXXtest"),
	qr/^[^X]{3}test$/,
	'Prefix template: "XXXtest"' ) ;

# suffix template
like( IkiWiki::Plugin::mktemp::mktemp("testXXX"),
	qr/^test[^X]{3}$/,
	'Suffix template (standard): "testXXX"' ) ;

# muliple templates
like( IkiWiki::Plugin::mktemp::mktemp("XXXtestXXX"),
	qr/^XXXtest[^X]{3}$/,
	'Multiple template strings: "XXXtestXXX"' ) ;

# common usage
like( IkiWiki::Plugin::mktemp::mktemp("test.XXXXX"),
	qr/^test\.[^X]{5}$/,
	'Suffix template (common): "test.XXXXX"' ) ;

# suffix template with file suffix
like( IkiWiki::Plugin::mktemp::mktemp("test-XXXX.txt"),
	qr/^test-[^X]{4}.txt$/,
	'Suffix template, with extension: "test-XXXX.txt"' ) ;

# prefix template with file suffix
like( IkiWiki::Plugin::mktemp::mktemp("XXXXXXXX-test.txt"),
	qr/^[^X]{8}-test.txt$/,
	'Prefix template, with extension: "XXXXXXXX-test.txt"' ) ;

# long test
like( IkiWiki::Plugin::mktemp::mktemp("X"x1024),
	qr/^[^X]{1024}$/,
	'Long template (1024 chars): "X"x1024' ) ;
