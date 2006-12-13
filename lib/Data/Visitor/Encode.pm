# $Id: /mirror/perl/Data-Visitor-Encode/trunk/lib/Data/Visitor/Encode.pm 4460 2006-12-13T10:17:16.290415Z daisuke  $
#
# Copyright (c) 2006 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package Data::Visitor::Encode;
use strict;
use base qw(Data::Visitor);
use Encode();

BEGIN
{
    our $VERSION = '0.01';
    __PACKAGE__->mk_accessors('visit_method', 'extra_args');
}

sub visit_glob
{
    require Carp;
    Carp::carp("Data::Visitor::Encode Can't work with globs");
}

# We care about the hash key as well, so override
sub visit_hash
{
    my ($self, $hash) = @_;

    my %map = map {
        (
            $self->visit_value($_),
            $self->visit_value($hash->{$_})
        )
    } keys %$hash;
    return \%map;
}

sub visit_value
{
    my ($self, $data) = @_;

    # return as-is if undefined
    return $data unless defined $data;

    # return as-is if no method
    my $method = $self->visit_method();
    return $data unless $method;

    # return if unimplemented
    $method = "do_$method";
    return $data if (! $self->can($method));

    return $self->$method($data);
}

sub do_utf8_on
{
    my $self = shift;
    my $data = shift;

    Encode::_utf8_on($data);
    return $data;
}

sub do_utf8_off
{
    my $self = shift;
    my $data = shift;

    Encode::_utf8_off($data);
    return $data;
}

sub utf8_on
{
    my $self = shift;
    $self->visit_method('utf8_on');
    $self->visit($_[0]);
}

sub utf8_off
{
    my $self = shift;
    $self->visit_method('utf8_off');
    $self->visit($_[0]);
}

sub do_encode
{
    my $self = shift;
    my $data = shift;
    return Encode::encode($self->extra_args, $data);
}

sub do_decode
{
    my $self = shift;
    my $data = shift;
    return Encode::decode($self->extra_args, $data);
}

sub decode
{
    my $self = shift;
    my $code = shift;

    $self->extra_args($code);
    $self->visit_method('decode');
    $self->visit($_[0]);
}

sub encode
{
    my $self = shift;
    my $code = shift;

    $self->extra_args($code);
    $self->visit_method('encode');
    $self->visit($_[0]);
}

1;

__END__

=head1 NAME

Data::Visitor::Encode - Encode/Decode Values In A Structure

=head1 SYNOPSIS

  use Data::Visitor::Encode;

  my $ev = Data::Visitor::Encode->new();
  my %hash = (...); # assume data is in Perl native Unicode
  $ev->encode('euc-jp', \%hash); # now strings are in euc-jp
  $ev->decode('euc-jp', \%hash); # now strings are back in unicode
  $ev->utf8_on(\%hash);
  $ev->utf8_off(\%hash);

=head1 DESCRIPTION

Data::Visitor::Encode visits each node of a structure, and returns a new
structure with each node's encoding (or similar action). If you ever wished
to do a bulk encode/decode of the contents of a structure, then this
module may help you.

=head1 METHODS

=head2 utf8_on

  $ev->utf8_on(\%hash);
  $ev->utf8_on(\@list);
  $ev->utf8_on(\$scalar);
  $ev->utf8_on($scalar);

Returns a structure containing nodes with utf8 flag on

=head2 utf8_off

  $ev->utf8_off(\%hash);
  $ev->utf8_off(\@list);
  $ev->utf8_off(\$scalar);
  $ev->utf8_off($scalar);

Returns a structure containing nodes with utf8 flag off

=head2 encode

  $ev->encode($encoding, \%hash);
  $ev->encode($encoding, \@list);
  $ev->encode($encoding, \$scalar);
  $ev->encode($encoding, $scalar);

Returns a stricture contains nodes which are encoded in the specified
encoding.

=head2 decode

  $ev->decode($encoding, \%hash);
  $ev->decode($encoding, \@list);
  $ev->decode($encoding, \$scalar);
  $ev->decode($encoding, $scalar);

Returns a stricture contains nodes which are decoded from the specified
encoding.

=head1 AUTHOR

Daisuke Maki E<lt>daisuke@endeworks.jp<gt>

=head1 SEE ALSO

L<Data::Visitor|Data::Visitor>, L<Encode|Encode>

=cut