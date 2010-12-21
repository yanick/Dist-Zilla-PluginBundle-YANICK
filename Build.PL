
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Carp' => '0',
    'Module::Build' => '0.3601',
    'Scalar::Util' => '0',
    'Test::More' => '0.94',
    'perl' => '5.004'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Be like Yanick when you build your dists',
  'dist_author' => [
    'Yanick Champoux <yanick@babyl.dyndns.org>'
  ],
  'dist_name' => 'Dist-Zilla-PluginBundle-YANICK',
  'dist_version' => '0.0.1',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::PluginBundle::YANICK',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Dist::Zilla::Plugin::Bugtracker' => '0',
    'Dist::Zilla::Plugin::GithubMeta' => '0',
    'Dist::Zilla::Plugin::Homepage' => '0',
    'Dist::Zilla::Plugin::License' => '0',
    'Dist::Zilla::Plugin::MetaJSON' => '0',
    'Dist::Zilla::Plugin::MetaProvides::Package' => '0',
    'Dist::Zilla::Plugin::MetaYAML' => '0',
    'Dist::Zilla::Plugin::ModuleBuild' => '0',
    'Dist::Zilla::Plugin::NextRelease' => '0',
    'Dist::Zilla::Plugin::PodWeaver' => '0',
    'Dist::Zilla::Plugin::ReadmeFromPod' => '0',
    'Dist::Zilla::Role::PluginBundle::Easy' => '0',
    'Moose' => '0'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
