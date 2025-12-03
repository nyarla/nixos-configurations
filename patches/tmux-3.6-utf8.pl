#!/usr/bin/env perl

use v5.40;

my @half = (
    0x1F1E6, 0x1F1E7, 0x1F1E8, 0x1F1E9, 0x1F1EA, 0x1F1EB, 0x1F1EC, 0x1F1ED,
    0x1F1EE, 0x1F1EF, 0x1F1F0, 0x1F1F1, 0x1F1F2, 0x1F1F3, 0x1F1F4, 0x1F1F5,
    0x1F1F6, 0x1F1F7, 0x1F1F8, 0x1F1F9, 0x1F1FA, 0x1F1FB, 0x1F1FC, 0x1F1FD,
    0x1F1FE, 0x1F1FF,
);

my @full = map {
    my $range = $_;
    $range =~ s{U\+}{};
    my ( $start, $end ) = split qr{-}, $range;
    hex($start) .. hex($end)
  } split q{,},
"U+2030-2031,U+203B-203B,U+2121-2121,U+213B-213B,U+214F-214F,U+2160-2182,U+2190-21FF,U+2318-2318,U+2325-2325,U+2460-24FF,U+25A0-25D7,U+25D9-25E5,U+25E7-2653,U+2668-2668,U+2670-2712,U+2744-2744,U+2747-2747,U+2763-2763,U+2776-2793,U+27F5-27FF,U+2B33-2B33,U+3248-324F,U+E000-EDFF,U+EE0C-F8FF,U+1F000-1F02B,U+1F030-1F093,U+1F0A0-1F0F5,U+1F100-1FAF8,U+F0000-10FFFD";

my @codepoints = sort { $a <=> $b } ( @half, @full );

say <<'...';
#ifndef UTF8_WIDTH
#define UTF8_WIDTH

static struct utf8_width_item utf8_default_width_cache[] = {
...

for my ( $idx, $code ) ( indexed @codepoints ) {
    if ( grep { $code eq $_ } @half ) {
        print sprintf( "\t{ .wc = 0x%X, .width = 1 }", $code );
    }
    else {
        print sprintf( "\t{ .wc = 0x%X, .width = 2 }", $code );
    }

    if ( $idx == $#codepoints ) {
        print "\n";
    }
    else {
        print ",\n";
    }
}

say <<'...';
};
#endif
...
