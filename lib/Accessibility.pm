# $Id: Accessibility.pm,v 1.3 2005/03/08 23:23:37 comdog Exp $
package Test::WWW::Accessibility;
use strict;

use base qw( Exporter );
use vars qw( $VERSION @EXPORT_OK @EXPORT );

$VERSION = '0.11_01';
@EXPORT  = qw( img_tags_have_alt_ok );

use Test::Builder;

my $Test = Test::Builder->new();

=head1 NAME

Test::WWW::Accessibility;

=head1 SYNOPSIS

	use Test::More tests => 1;
	use Test::WWW::Accessibility;

	my $html = ...;

	img_tags_have_alt_ok( $html );

	# more functions to come

=head1 DESCRIPTION

This module provides functions to check a web page for accessibility

=head2 Functions

All of these functions are exported by default.

=over 4

=item accessibility_ok( HTML )

This function will run several other of the tests and return a 
single answer.  

NOT YET IMPLEMENTED

=cut

sub accessibility_ok
	{

	}

=item img_tags_have_alt_ok( HTML [, NAME] )

OK if all of the IMG tags in HTML have non-empty ALT values (so the
empty string does not count!).

You can specify a name for the test as the optional, second argument.
If you don't, the function supplies on for you.

=cut

sub img_tags_have_alt_ok
	{
	my $name = $_[1] || 'IMG tags have ALT attributes';

	# parse HTML to get all IMG tags
	my @imgs = &_get_img_tags;
	#$Test->diag( "Got " . @imgs . " image tags" );

	# count ALT tags
	my $alts = grep { exists $_->{alt} && $_->{alt} } @imgs;
	#$Test->diag( "Got " . $alts . " ALT tags" );

	$Test->ok( @imgs == $alts, $name );
	}

sub _get_img_tags
	{
	my $html = shift;

	my @imgs = ();

	my $p = Test::WWW::Accessibility::ImgExtor->new( sub {
		my $tag = shift;
		return if $tag ne 'img';
		push @imgs, { @_ };
		} );

	$p->parse( $html );

	return @imgs;
	}

=item no_server_side_imagemaps_ok( HTML )

NOT YET IMPLEMENTED

=cut

sub no_server_side_imagemaps_ok
	{
	}

=item multimedia_has_caption_ok( HTML )

NOT YET IMPLEMENTED

=cut

sub multimedia_has_caption_ok
	{
	}

=item no_click_here_ok( HTML )

Link text is not "click here".

NOT YET IMPLEMENTED

=cut

sub no_click_here_ok
	{
	}

=item unique_link_text_ok( HTML )

Link text for each URL is unique.

NOT YET IMPLEMENTED

=cut

sub unique_link_text_ok()
	{
	}

=item validates_ok( HTML )

NOT YET IMPLEMENTED

=cut

sub validates_ok
	{
	}

=back

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	http://sourceforge.net/projects/brian-d-foy/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

brian d foy, C<< <bdfoy@cpan.org> >>

=head1 COPYRIGHT

Copyright 2004 brian d foy, All rights reserved.

You can use this module under the same terms as
Perl itself.

=cut

package Test::WWW::Accessibility::ImgExtor;

use strict;

use HTML::Tagset ();
use base qw( HTML::Parser );

require HTML::Parser;

sub new
{
    my($class, $cb, $base) = @_;
    my $self = $class->SUPER::new(
                    start_h => ["_start_tag", "self,tagname,attr"],
		    report_tags => [keys %HTML::Tagset::linkElements],
	       );
    $self->{extractlink_cb} = $cb;
    if ($base) {
	require URI;
	$self->{extractlink_base} = URI->new($base);
    }
    $self;
}

sub _start_tag
{
    my($self, $tag, $attr) = @_;

    my $base = $self->{extractlink_base};
    my $links = [ qw( src alt ) ];
    $links = [$links] unless ref $links;

    my @links;
    my $a;
    for $a (@$links) {
	next unless exists $attr->{$a};
	push(@links, $a, $base ? URI->new($attr->{$a}, $base)->abs($base)
                               : $attr->{$a});
    }
    return unless @links;
    $self->_found_link($tag, @links);
}

sub _found_link
{
    my $self = shift;
    my $cb = $self->{extractlink_cb};
    if ($cb) {
	&$cb(@_);
    } else {
	push(@{$self->{'links'}}, [@_]);
    }
}

# We override the parse_file() method so that we can clear the links
# before we start a new file.
sub parse_file
{
    my $self = shift;
    delete $self->{'links'};
    $self->SUPER::parse_file(@_);
}


1;
