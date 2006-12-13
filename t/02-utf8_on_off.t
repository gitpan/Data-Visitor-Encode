use strict;
use utf8;
use Test::More tests => 13;

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
my $visited = $ev->utf8_off(\%source);
while (my($key, $value) = each %$visited) {
    ok(! Encode::is_utf8($key), "Assert key is NOT utf8");
    ok(! Encode::is_utf8($value), "Assert value is NOT utf8");
}

$visited = $ev->utf8_on($visited);
while (my($key, $value) = each %$visited) {
    ok(Encode::is_utf8($key), "key is utf8");
    ok(Encode::is_utf8($value), "value is utf8");
}

# List
my @source = ($nihongo, $aiueo);
$visited = $ev->utf8_off(\@source);
foreach (@$visited) {
    ok(! Encode::is_utf8($_), "Assert value is NOT utf8");
}

$visited = $ev->utf8_on($visited);
foreach (@$visited) {
    ok(Encode::is_utf8($_), "Assert value is utf8");
}

# Scalar (Ref)
my $source = \$nihongo;
$visited = $ev->utf8_off($source);
ok(! Encode::is_utf8($$visited), "Assert value is NOT utf8");

$visited = $ev->utf8_on($visited);
ok(Encode::is_utf8($$visited), "Assert value is utf8");

# Scalar
$source = $nihongo;
$visited = $ev->utf8_off($source);
ok(! Encode::is_utf8($visited), "Assert value is NOT utf8");

$visited = $ev->utf8_on($visited);
ok(Encode::is_utf8($visited), "Assert value is utf8");

1;
