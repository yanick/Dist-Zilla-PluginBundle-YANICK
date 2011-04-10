package Dist::Zilla::Plugin::Author::YANICK::NextSemanticVersion;
# ABSTRACT: update the next version, semantic-wise

use strict;
use warnings;

use Git::Repository;
use CPAN::Changes;
use Perl::Version;

use Moose;
with 'Dist::Zilla::Role::FileMunger';
with 'Dist::Zilla::Role::TextTemplate';
with 'Dist::Zilla::Role::AfterRelease';
with 'Dist::Zilla::Role::VersionProvider';

has version_regexp  => ( is => 'ro', isa=>'Str', default => '^v(.+)$' );

has first_version  => ( is => 'ro', isa=>'Str', default => '0.1.0' );

has filename  => ( is => 'ro', isa=>'Str', default => 'Changes' );

my @major_groups = ('API CHANGES');
my @minor_groups = ('ENHANCEMENTS');
my @revision_groups = ('BUG FIXES');

sub after_release {
  my ($self) = @_;
  my $filename = $self->filename;

  # read original changelog
  my $content = do {
    local $/;
    open my $in_fh, '<', $filename
      or Carp::croak("can't open $filename for reading: $!");

    # Win32
    binmode $in_fh, ':raw';
    <$in_fh>
  };

  my $skel = join '', map { "  [$_]\n\n" }  
                 @major_groups, @minor_groups, @revision_groups;

  # add the version and date to file content
  my $delim  = $self->delim;
  $content =~ s{( (\Q$delim->[0]\E \s*) \$NEXT (\s* \Q$delim->[1]\E) )}
               {$1\n\n$skel}xs;

  $self->log_debug([ 'updating contents of %s on disk', $filename ]);

  # and finally rewrite the changelog on disk
  open my $out_fh, '>', $filename
    or Carp::croak("can't open $filename for writing: $!");

  # Win32.
  binmode $out_fh, ':raw';
  print $out_fh $content or Carp::croak("error writing to $filename: $!");
  close $out_fh or Carp::croak("error closing $filename: $!");
}

# stolen and adapted from D::Z::P::Git::NextVersion
sub provide_version {
  my $self = shift;

  # override (or maybe needed to initialize)
  return $ENV{V} if exists $ENV{V};

  local $/ = "\n"; # Force record separator to be single newline

  my $git  = Git::Repository->new( work_tree => '.');
  my $regexp = $self->version_regexp;

  # TODO actually, should be after the next stanza
  my @tags = $git->run('tag') or return $self->first_version;

  # find highest version from tags
  my ($last_ver) =  sort { version->parse($b) <=> version->parse($a) }
  grep { eval { version->parse($_) }  }
  map  { /$regexp/ ? $1 : ()          } @tags;

  $self->log_fatal("Could not determine last version from tags")
  unless defined $last_ver;

  my $new_ver = $self->next_version($last_ver);

  $self->zilla->version("$new_ver");
}

sub next_version {
    my( $self, $last_version ) = @_;

    my ($changes_file) = grep { $_->name eq $self->filename } @{ $self->zilla->files };

    my $changes = CPAN::Changes->load_string( $changes_file->content,
        next_token => qr/{{\$NEXT}}/ ); 

    my ($next) = reverse $changes->releases;

    my $new_ver = $self->inc_version( 
        $last_version, 
        grep { scalar @{ $next->changes($_) } } $next->groups 
    );

    $self->log("Bumping version from $last_version to $new_ver");
    return $new_ver;
}

sub inc_version {
    my ( $self, $last_version, @groups ) = @_;

    $last_version = Perl::Version->new( $last_version );

    for ( @major_groups ) {
        next unless $_ ~~ @groups;
        $last_version->inc_revision;
        return $last_version
    }
    for ( @minor_groups ) {
        next unless $_ ~~ @groups;
        $last_version->inc_version;
        return $last_version
    }

    $last_version->inc_subversion;
    return $last_version;
}

sub munge_files {
  my ($self) = @_;

  my ($file) = grep { $_->name eq 'Changes' } @{ $self->zilla->files };
  return unless $file;

  my $changes = CPAN::Changes->load_string( $file->content, 
      next_token => qr/{{\$NEXT}}/
  );

  my ( $next ) = reverse $changes->releases;

    $next->delete_group(
        grep { !@{$next->changes($_)} } $next->groups 
    );

  $self->log_debug([ 'updating contents of %s in memory', $file->name ]);
  $file->content($changes->serialize);
}


__PACKAGE__->meta->make_immutable;
no Moose;
1;

