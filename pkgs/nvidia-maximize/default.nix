{
  writeScriptBin,
  perl,
}:
writeScriptBin "nvidia-maximize" ''
  #!${perl}/bin/perl

  use strict;
  use warnings;
  use utf8;

  sub nvidia_smi :prototype($) {
    my $action = shift;
    `nvidia-smi ''${action}`;
  }

  sub powerLimit {
    for my $line (nvidia_smi "-q -d POWER") {
      if ($line =~ m{Current Power Limit} && $line !~ m{N/A}) {
        my $limit = ($line =~ m{(\d+)\.\d+})[0];
        return $limit;
      }
    }

    return undef;
  }

  sub clock : prototype($) {
    my $match = shift;
    my $clock = undef;
    for my $line (nvidia_smi "-q -d CLOCK") {
      if ($line =~ m{$match}) {
        my $value = ( $line =~ m{: (\d+) MHz} )[0];
        if (defined $value) {
          $value = int($value);
          if (!defined $clock || $clock < $value) {
            $clock = $value;
          }
        }
      }
    }
    return $clock;
  }

  sub main {
    my $action = shift;

    if (! defined $action) {
      print "usage: ''${0} [set|reset]\n";
      return;
    }

    if ($action eq 'set') {
      my $pl = powerLimit;
      my $gc = clock "SM";
      my $mc = clock "Memory";

      return if ! defined $pl;
      return if ! defined $gc;
      return if ! defined $mc;

      if ( $pl > 0 && $gc > 0 && $mc > 0 ) {
        print nvidia_smi("-pl ''${pl}");
        print nvidia_smi("-lgc ''${gc}");
        print nvidia_smi("-lmc ''${mc}");
      }
    }
    elsif ($action eq 'reset') {
      print nvidia_smi("-rgc");
      print nvidia_smi("-rmc");
    }
  }

  main(@ARGV);
''
