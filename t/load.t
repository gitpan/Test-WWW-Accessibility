# $Id: load.t,v 1.1.1.1 2004/10/12 13:11:55 comdog Exp $
BEGIN {
	@classes = qw(Test::WWW::Accessibility);
	}

use Test::More tests => scalar @classes;

foreach my $class ( @classes )
	{
	print "bail out! $class did not compile\n" unless use_ok( $class );
	}
