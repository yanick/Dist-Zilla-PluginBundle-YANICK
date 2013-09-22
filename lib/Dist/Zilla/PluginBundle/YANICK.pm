package Dist::Zilla::PluginBundle::YANICK;
BEGIN {
  $Dist::Zilla::PluginBundle::YANICK::AUTHORITY = 'cpan:YANICK';
}
{
  $Dist::Zilla::PluginBundle::YANICK::VERSION = '0.18.1';
}

# ABSTRACT: Be like Yanick when you build your dists


use strict;

use Moose;

use Dist::Zilla::Plugin::ContributorsFile;
use Dist::Zilla::Plugin::ContributorsFromGit;
use Dist::Zilla::Plugin::ModuleBuild;
use Dist::Zilla::Plugin::GithubMeta;
use Dist::Zilla::Plugin::Homepage;
use Dist::Zilla::Plugin::Bugtracker;
use Dist::Zilla::Plugin::MetaYAML;
use Dist::Zilla::Plugin::MetaJSON;
use Dist::Zilla::Plugin::PodWeaver;
use Dist::Zilla::Plugin::License;
use Dist::Zilla::Plugin::ReadmeFromPod;
use Dist::Zilla::Plugin::NextRelease;
use Dist::Zilla::Plugin::MetaProvides::Package;
use Dist::Zilla::Plugin::InstallRelease;
use Dist::Zilla::Plugin::InstallGuide 1.200000;
use Dist::Zilla::Plugin::Twitter 0.019;
use Dist::Zilla::Plugin::Signature;
use Dist::Zilla::Plugin::Git;
use Dist::Zilla::Plugin::CoalescePod;
use Dist::Zilla::Plugin::Test::Compile 2.033;
use Dist::Zilla::Plugin::Covenant;
use Dist::Zilla::Plugin::SchwartzRatio;
use Dist::Zilla::Plugin::PreviousVersion::Changelog;
use Dist::Zilla::Plugin::ChangeStats::Git;
use Dist::Zilla::Plugin::Test::UnusedVars;
use Dist::Zilla::Plugin::RunExtraTests;
use Dist::Zilla::Plugin::HelpWanted;
use Dist::Zilla::Plugin::CoderwallEndorse;
use Dist::Zilla::Plugin::NextVersion::Semantic;

with 'Dist::Zilla::Role::PluginBundle::Easy';

sub configure {
    my ( $self ) = @_;
    my $arg = $self->payload;

    my $release_branch = 'releases';
    my $upstream       = 'github';

    my %mb_args;
    $mb_args{mb_class} = $arg->{mb_class} if $arg->{mb_class};
    $self->add_plugins([ 'ModuleBuild', \%mb_args ]);

    $self->add_plugins(
        qw/ 
            ContributorsFromGit
            ContributorsFile
            Test::Compile
            CoalescePod
            InstallGuide
            Covenant
        /,
        [ GithubMeta => { remote => $upstream, } ],
        qw/ Homepage Bugtracker MetaYAML MetaJSON PodWeaver License
          ReadmeFromPod 
          ReadmeMarkdownFromPod
          /,
        [ CoderwallEndorse => { users => 'yanick:Yanick' } ],
        [ NextRelease => { 
                time_zone => 'America/Montreal',
                format    => '%-9v %{yyyy-MM-dd}d',
            } ],
        'MetaProvides::Package',
        qw/ MatchManifest
          ManifestSkip /,
        [ GatherDir => {
                include_dotfiles => $arg->{include_dotfiles},
              } ],
        qw/ ExecDir
          PkgVersion /,
          [ Authority => { 
            ( authority => $arg->{authority} ) x !!$arg->{authority}  
          } ],
          qw/ ReportVersions::Tiny
          Signature /,
          [ AutoPrereqs => { 
                  ( skip => $arg->{autoprereqs_skip} ) 
                            x !!$arg->{autoprereqs_skip}
            } 
          ],
          qw/ CheckChangesHasContent
          TestRelease
          ConfirmRelease
          Git::Check
          /,
        [ 'Git::CommitBuild' => { release_branch => $release_branch } ],
        [ 'Git::Tag'  => { tag_format => 'v%v', branch => $release_branch } ],
    );

    # Git::Commit can't be before Git::CommitBuild :-/
    $self->add_plugins(
        'PreviousVersion::Changelog',
        [ 'NextVersion::Semantic' => {
            major => 'API CHANGES',
            minor => 'NEW FEATURES, ENHANCEMENTS',
            revision => 'BUG FIXES, DOCUMENTATION, STATISTICS',
        } ],
        [ 'ChangeStats::Git' => { group => 'STATISTICS' } ],
        'Git::Commit',
    );

    if ( $ENV{FAKE} or $arg->{fake_release} ) {
        $self->add_plugins( 'FakeRelease' );
    }
    else {
        $self->add_plugins(
            [ 'Git::Push' => { push_to    => $upstream } ],
            qw/
                UploadToCPAN
            /,
            [ Twitter => {
                tweet_url =>
                    'https://metacpan.org/release/{{$AUTHOR_UC}}/{{$DIST}}-{{$VERSION}}/',
                tweet => 
                    'Released {{$DIST}}-{{$VERSION}}{{$TRIAL}} {{$URL}} !META{resources}{repository}{web}',
                url_shortener => 'none',
            } ],
            [ 'InstallRelease' => { install_command => 'cpanm .' } ],
        );
    }
    
    $self->add_plugins(
    qw/
        SchwartzRatio 
    /,
        'Test::UnusedVars',
        'RunExtraTests',
    );

    if ( my $help_wanted = $arg->{help_wanted} ) {
        $self->add_plugins([
            'HelpWanted' => {
                map { $_ => 1 } split ' ', $help_wanted
            },
        ]);
    }

    $self->config_slice( 'mb_class' );

    return;
}

1;

__END__

=pod

=head1 NAME

Dist::Zilla::PluginBundle::YANICK - Be like Yanick when you build your dists

=head1 VERSION

version 0.18.1

=head1 DESCRIPTION

This is the plugin bundle that Yanick uses to release
his distributions. It's roughly equivalent to

    [ContributorsFromGit]
    [ContributorsFile]

    [Test::Compile]

    [CoalescePod]

    [ModuleBuild]

    [InstallGuide]
    [Covenant]

    [GithubMeta]
    remote=github

    [Homepage]
    [Bugtracker]

    [MetaYAML]
    [MetaJSON]

    [PodWeaver]

    [License]
    [HelpWanted]

    [ReadmeFromPod]
    [ReadmeMarkdownFromPod]

    [CoderwallEndorse]
    users = yanick:Yanick

    [NextRelease]
    time_zone = America/Montreal

    [MetaProvides::Package]

    [MatchManifest]
    [ManifestSkip]

    [GatherDir]
    [ExecDir]

    [PkgVersion]
    [Authority]

    [ReportVersions::Tiny]
    [Signature]

    [AutoPrereqs]

    [CheckChangesHasContent]

    [TestRelease]

    [ConfirmRelease]

    [Git::Check]

    [PreviousVersion::Changelog]
    [NextVersion::Semantic]

    [ChangeStats::Git]
    group=STATISTICS

    [Git::Commit]
    [Git::CommitBuild]
        release_branch = releases
    [Git::Tag]
        tag_format = v%v
        branch     = releases

    [UploadToCPAN]

    [Git::Push]
        push_to = github

    [InstallRelease]
    install_command = cpanm .

    [Twitter]
    [SchwartzRatio]


    [RunExtraTests]
    [Test::UnusedVars]

=head2 ARGUMENTS

=head3 autoprereqs_skip

Passed as C<skip> to AutoPrereqs.

=head3 authority

Passed to L<Dist::Zilla::Plugin::Authority>.

=head3 fake_release

If given a true value, uses L<Dist::Zilla::Plugin::FakeRelease>
instead of 
L<Dist::Zilla::Plugin::Git::Push>,
L<Dist::Zilla::Plugin::UploadToCPAN>,
L<Dist::Zilla::Plugin::InstallRelease> and
L<Dist::Zilla::Plugin::Twitter>.

Can also be triggered via the I<FAKE> environment variable.

=head3 mb_class

Passed to C<ModuleBuild> plugin.

=head3 include_dotfiles

For C<GatherDir>. Defaults to false.

=head1 AUTHOR

Yanick Champoux <yanick@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
