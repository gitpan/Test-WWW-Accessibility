# $Id: img_tags_have_alt_ok.t,v 1.2 2004/10/12 15:31:47 comdog Exp $
use strict;

use Test::Builder::Tester;
use Test::More tests => 10;

use_ok( 'Test::WWW::Accessibility' );

{
local $^W = 0;
*Test::WWW::Accessibility::img_tags_have_alt_ok{CODE};
ok( defined *Test::WWW::Accessibility::img_tags_have_alt_ok{CODE},
	"img_tags_have_alt_ok defined" );
ok( defined *main::img_tags_have_alt_ok{CODE},
	"img_tags_have_alt_ok defined" );
}

{
my $file = 'html/brian.html';
ok( -e $file, 'File [ $file ] exists' );

my $html = do { local $/; open my($fh), $file; <$fh> };

ok( defined $html, "Got test content" );

test_out( 'ok 1 - IMG tags have ALT attributes' );
img_tags_have_alt_ok( $html );
test_test();

test_out( 'ok 1 - I have ALT tags!' );
img_tags_have_alt_ok( $html, "I have ALT tags!" );
test_test();
}

{
my $file = 'html/no_alts.html';
ok( -e $file, 'File [ $file ] exists' );

my $html = do { local $/; open my($fh), $file; <$fh> };

ok( defined $html, "Got test content" );

test_out( 'not ok 1 - IMG tags have ALT attributes' );
test_err("#     Failed test ($0 at line ".line_num(+1).")");
img_tags_have_alt_ok( $html );
test_test();
}