package Dist::Zilla::MintingProfile::Author::YANICK;
# ABSTRACT: create distributions like YANICK

use strict;
use warnings;

use Moose;

with 'Dist::Zilla::Role::MintingProfile::ShareDir';

__PACKAGE__->meta->make_immutable;

1;
