#!/usr/bin/perl

# Build the possible permutations of a 2x2x2 cube built up of red, green
# blue bricks.
# Dismiss duplicates after rotating.
# Count only unique cubes.

use warnings;
use strict;

use feature 'say';

use Data::Dumper;

use Algorithm::Permute;

# Hash of arrays for rotating the cubes later
my @permutations = ();

# Keep track of already seen permutations and skip them if only bricks
# of the same colors have been permuted
# Hash of strings only for keeping the arrays unique
my %already_seen_permutation = ();

# Keep track of actual cubes and not permutations that still can be rotated
my %unique_cubes = ();

# Build unique permutations of bricks, but dismiss duplicates
my $max_blue  = 6;
for my $red (1..6) {
	my $green = 1;
	for (my $blue = $max_blue; $blue >= 1; $blue--) {
		
		my @bricks = split(//, ('r' x $red) . ('g' x $green) . ('b' x $blue));
		my $p_iterator = Algorithm::Permute->new ( \@bricks );
		
		while (my @perm = $p_iterator->next) {
			my $serialized = join('', @perm);
			
			next if exists $already_seen_permutation{$serialized};
			
			push @permutations, \@perm;
			$already_seen_permutation{$serialized} = 1;
		}

		$green++;
	}
	$max_blue--;
}

# Count only unique cubes
foreach my $permutation (@permutations) {

	# Rotate each cube and dismiss duplicates
	next if exists $unique_cubes{rotx90( $permutation)};
	next if exists $unique_cubes{rotx180($permutation)};
	next if exists $unique_cubes{roty90( $permutation)};
	next if exists $unique_cubes{roty180($permutation)};
	next if exists $unique_cubes{rotz90( $permutation)};
	next if exists $unique_cubes{rotz180($permutation)};
	$unique_cubes{join('',@{$permutation})} = 1;
}

say Dumper keys %unique_cubes;

# Argument:     arrayref of brick letters
# Return value: serialized string of rotated array
sub rotx90 {
	return join('',@{$_[0]}[2,3,6,7,0,1,4,5]);
}
sub rotx180 {
	return join('',@{$_[0]}[6,7,4,5,2,3,0,1]);
}
sub roty90 {
	return join('',@{$_[0]}[4,0,6,2,5,1,7,3]);
}
sub roty180 {
	return join('',@{$_[0]}[5,4,7,6,1,0,3,2]);
}
sub rotz90 {
	return join('',@{$_[0]}[2,3,6,7,0,1,4,5]);
}
sub rotz180 {
	return join('',@{$_[0]}[3,2,1,0,7,6,5,4]);
}
