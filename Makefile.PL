# $Id: Makefile.PL,v 1.2 2004/10/12 15:25:17 comdog Exp $
use ExtUtils::MakeMaker;

eval "use Test::Manifest";
unless( $@ )
   {
   * ExtUtils::MM_Any::test_via_harness = sub
	   {
	   my($self, $perl, $tests) = @_;

	   return qq|\t$perl "-MTest::Manifest" | .
				  qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', | .
				  qq|'\$(INST_ARCHLIB)')"\n|;
	   }
   }

WriteMakefile(
	'NAME'	       => 'Test::WWW::Accessibility',
	'VERSION_FROM' => 'lib/Accessibility.pm',

	'PREREQ_PM'    => { 
		'HTML::Parser'          => '0',
		'HTML::Tagset'          => '0',
		'Test::Builder'         => '0',
		'Test::Builder::Tester' => '0',
		'URI'                   => '0',
		},

	'PM'           => {
		'lib/Accessibility.pm'  => '$(INST_LIBDIR)/Accessibility.pm',
		},

	'MAN3PODS'     => {
		'lib/Accessibility.pm' => '$(INST_MAN3DIR)/Test::WWW::Accessibility.3',
		},

	clean  => { FILES    => q|Test-WWW-*| },

	);

1;