use strict;
use utf8;
use Test::More tests => 13;
use Encode;

BEGIN
{
    use_ok("Data::Visitor::Encode");
}

my $nihongo = "日本語";
my $aiueo   = "あいうえお";
my %source = ($nihongo => $aiueo);
my %visited;

my $ev = Data::Visitor::Encode->new();

# Hash
my $visited = $ev->encode('euc-jp', \%source);
while (my($key, $value) = each %$visited) {
    is($key, encode('euc-jp', $nihongo), "Key is in euc-jp");
    is($value, encode('euc-jp', $aiueo), "Value is in euc-jp");
}

$visited = $ev->decode('euc-jp', $visited);
while (my($key, $value) = each %$visited) {
    is($key, $nihongo, "Key is UTF-8");
    is($value, $aiueo, "Key is UTF-8");
}

# List
my @source = ($nihongo, $aiueo);
$visited = $ev->encode('euc-jp', \@source);
is($visited->[0], encode('euc-jp', $nihongo), "Vallue is in euc-jp");
is($visited->[1], encode('euc-jp', $aiueo), "Value is in euc-jp");

$visited = $ev->decode('euc-jp', $visited);
is($visited->[0], $nihongo, "Vallue is in UTF-8");
is($visited->[1], $aiueo, "Value is in UTF-8");

# Scalar (Ref)
my $source = \$nihongo;
$visited = $ev->encode('euc-jp', $source);
is($$visited, encode('euc-jp', $nihongo), "Value is in euc-jp");

$visited = $ev->decode('euc-jp', $visited);
is($$visited, $nihongo, "Value is in UTF-8");

# Scalar
$source = $nihongo;
$visited = $ev->encode('euc-jp', $source);
is($visited, encode('euc-jp', $nihongo), "Value is in euc-jp");

$visited = $ev->decode('euc-jp', $visited);
is($visited, $nihongo, "Value is UTF-8");

1;
