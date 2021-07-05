#!/usr/bin/env perl

use strict;
use warnings;

my %e = (
  "&" => "&amp;",
  ">" => "&gt;",
  "<" => "&lt;",
  "'" => "&#39;",
  '"' => "&quot;",
);

sub escape_xml {
  my $src = shift @_;
  $src =~ s{([&><'"])}{$e{$1}}g;
  return $src;
}

print qq{<openbox_pipe_menu label="Windows">\n};

for my $item (sort { $a cmp $b } `wmctrl -l`) {
  chomp($item);
  my @data = split qr{ +}, $item;

  my $wid   = shift @data;
  my $did   = shift @data;
  my $mn    = shift @data;
  my $title = escape_xml(join q{ }, @data);

  if ( $title =~ m{^polybar} ) {
    next;
  }

  print qq{<item label="${title}">\n};
  print qq{<action name="Execute"><command>wmctrl -i -a ${wid}</command></action>\n};
  print qq{</item>\n};
}

print qq{</openbox_pipe_menu>\n};
