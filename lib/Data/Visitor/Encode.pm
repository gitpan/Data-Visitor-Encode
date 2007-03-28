# $Id: /mirror/perl/Data-Visitor-Encode/trunk/lib/Data/Visitor/Encode.pm 6215 2007-03-28T11:42:23.243798Z daisuke  $
#
# Copyright (c) 2006 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

package Data::Visitor::Encode;
use strict;
use base qw(Data::Visitor);
use Encode();
use Scalar::Util qw(reftype blessed);

BEGIN
{
    our $VERSION = '0.04';
    __PACKAGE__->mk_accessors('visit_method', 'extra_args');
}

sub visit_glob
{
    return $_[1];
}

# We care about the hash key as well, so override
sub visit_hash
{
    my ($self, $hash) = @_;

    my %map = map {
        (
            $self->visit_value($_),
            $self->visit($hash->{$_})
        )
    } keys %$hash;
    return \%map;
}

sub visit_object
{
    my ($self, $data) = @_;

    my $type = lc (reftype $data);
    $type = 'value' if $type eq 'scalar';

    my $method = "visit_$type";
    my $ret    = $self->$method($data);

    return bless $ret, blessed $data;
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

  my $dev = Data::Visitor::Encode->new();
  my %hash = (...); # assume data is in Perl native Unicode
  $dev->encode('euc-jp', \%hash); # now strings are in euc-jp
  $dev->decode('euc-jp', \%hash); # now strings are back in unicode
  $dev->utf8_on(\%hash);
  $dev->utf8_off(\%hash);

=head1 DESCRIPTION

Data::Visitor::Encode visits each node of a structure, and returns a new
structure with each node's encoding (or similar action). If you ever wished
to do a bulk encode/decode of the contents of a structure, then this
module may help you.

=head1 METHODS

=head2 utf8_on

  $dev->utf8_on(\%hash);
  $dev->utf8_on(\@list);
  $dev->utf8_on(\$scalar);
  $dev->utf8_on($scalar);
  $dev->utf8_on($object);

Returns a structure containing nodes with utf8 flag on

=head2 utf8_off

  $dev->utf8_off(\%hash);
  $dev->utf8_off(\@list);
  $dev->utf8_off(\$scalar);
  $dev->utf8_off($scalar);
  $dev->utf8_off($object);

Returns a structure containing nodes with utf8 flag off

=head2 encode

  $dev->encode($encoding, \%hash   [, CHECK]);
  $dev->encode($encoding, \@list   [, CHECK]);
  $dev->encode($encoding, \$scalar [, CHECK]);
  $dev->encode($encoding, $scalar  [, CHECK]);
  $dev->encode($encoding, $object  [, CHECK]);

Returns a structure containing nodes which are encoded in the specified
encoding.

=head2 decode

  $dev->decode($encoding, \%hash);
  $dev->decode($encoding, \@list);
  $dev->decode($encoding, \$scalar);
  $dev->decode($encoding, $scalar);
  $dev->decode($encoding, $object);

Returns a structure containing nodes which are decoded from the specified
encoding.

=head1 AUTHOR

Daisuke Maki E<lt>daisuke@endeworks.jpE<gt>

=head1 SEE ALSO

L<Data::Visitor|Data::Visitor>, L<Encode|Encode>

=cut