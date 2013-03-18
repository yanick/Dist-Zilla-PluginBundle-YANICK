package Dist::Zilla::Plugin::ContributorsFile;
# ABSTRACT: add a file listing all contributors

use strict;
use warnings;

use Moose;
use Dist::Zilla::File::InMemory;

with qw/
    Dist::Zilla::Role::Plugin
    Dist::Zilla::Role::InstallTool
    Dist::Zilla::Role::TextTemplate
/;

has filename => (
    is => 'ro',
    default => 'CONTRIBUTORS',
);

has contributors => (
    traits => [ 'Array' ],
    isa => 'ArrayRef',
    lazy => 1, 
    default => sub {
        my $self = shift;

        my ($p) = grep { ref $_ eq 'Dist::Zilla::Plugin::ContributorsFromGit' }  
            @{$self->zilla->plugins} or die __PACKAGE__." requires ContributorsFromGit to work";
        return [ @{$p->contributor_list} ];
    },
    handles => {
        has_contributors => 'count',
        all_contributors => 'elements',
    },
);

sub setup_installer {
    my $self = shift;

    unless ( $self->has_contributors ) {
        return $self->log( 'no contributor detected, skipping file' );
    }

    my $content = $self->fill_in_string(
        $self->contributors_template(), {   
            distribution        => uc $self->zilla->name,
        }
    );

    my $file = Dist::Zilla::File::InMemory->new({ 
            content => $content,
            name    => $self->filename,
        }
    );

    $self->add_file($file);
}

sub contributors_template {
    my $self = shift;

    my $text = <<'END_CONT';

# {{$distribution}} CONTRIBUTORS #

This is the (likely incomplete) list of people who have helped
make this distribution what it is, either via code contributions, 
patches, bug reports, help with troubleshooting, etc. A huge
thank to all of them.

END_CONT

    $text .= "\t * $_\n" for $self->all_contributors;

    return $text;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::Covenant - add the author's pledge to the distribution

=head1 VERSION

version 0.1.0

=head1 SYNOPSIS

In dist.ini:

    [Covenant]
    version = 1
    pledge_file = AUTHOR_PLEDGE

=head1 DESCRIPTION

C<Dist::Zilla::Plugin::Covenant> adds the file
'I<AUTHOR_PLEDGE>' to the distribution. The author
as defined in I<dist.ini> is taken as being the pledgee.

The I<META> file of the distribution is also modified to
include a I<x_author_pledge> stanza.

=head1 CONFIGURATION OPTIONS

=head2 version

Version of the pledge to use. 

Defaults to '1'.

=head2 pledge_file

Name of the file holding the pledge.

Defaults to 'AUTHOR_PLEDGE'.

=head1 AUTHOR

Yanick Champoux <yanick@babyl.dyndns.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

