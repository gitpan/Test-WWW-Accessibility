# $Id: _get_img_tags.t,v 1.1.1.1 2004/10/12 13:11:55 comdog Exp $
use strict;

use Test::More tests => 62;

use_ok( "Test::WWW::Accessibility" );

ok( defined *Test::WWW::Accessibility::_get_img_tags{CODE},
	"_get_img_tags defined" );
	
my @files = qw( html/brian.html );

foreach my $file ( @files )
	{
	ok( -e $file, "File [$file] exists" );
	
	my $html = do { local $/; open my($fh), $file; <$fh> };
	
	ok( defined $html, "Got test content" );
	
	my @imgs = Test::WWW::Accessibility::_get_img_tags( $html );
	
	is( scalar @imgs, 57, 'Extracted right number of links' );
		
	foreach my $img ( @imgs )
		{
		isa_ok( $img, 'HASH', 'Element is a hash' );
		}
	}