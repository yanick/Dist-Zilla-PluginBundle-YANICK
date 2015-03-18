requires "CPAN::Changes" => "0.17";
requires "Dist::Zilla" => "0";
requires "Dist::Zilla::Plugin::Authority" => "0";
requires "Dist::Zilla::Plugin::CPANFile" => "0";
requires "Dist::Zilla::Plugin::ChangeStats::Git" => "v0.2.1";
requires "Dist::Zilla::Plugin::CheckChangesHasContent" => "0";
requires "Dist::Zilla::Plugin::CoalescePod" => "0";
requires "Dist::Zilla::Plugin::CoderwallEndorse" => "0";
requires "Dist::Zilla::Plugin::ContributorsFile" => "0";
requires "Dist::Zilla::Plugin::ContributorsFromGit" => "0";
requires "Dist::Zilla::Plugin::Covenant" => "0";
requires "Dist::Zilla::Plugin::DOAP" => "0";
requires "Dist::Zilla::Plugin::Git" => "0";
requires "Dist::Zilla::Plugin::GithubMeta" => "0";
requires "Dist::Zilla::Plugin::HelpWanted" => "0";
requires "Dist::Zilla::Plugin::InstallGuide" => "1.200000";
requires "Dist::Zilla::Plugin::InstallRelease" => "0";
requires "Dist::Zilla::Plugin::License" => "0";
requires "Dist::Zilla::Plugin::MatchManifest" => "0";
requires "Dist::Zilla::Plugin::MetaJSON" => "0";
requires "Dist::Zilla::Plugin::MetaProvides::Package" => "0";
requires "Dist::Zilla::Plugin::MetaYAML" => "0";
requires "Dist::Zilla::Plugin::ModuleBuild" => "0";
requires "Dist::Zilla::Plugin::NextRelease" => "0";
requires "Dist::Zilla::Plugin::NextVersion::Semantic" => "v0.1.2";
requires "Dist::Zilla::Plugin::PodWeaver" => "0";
requires "Dist::Zilla::Plugin::PreviousVersion::Changelog" => "0";
requires "Dist::Zilla::Plugin::ReadmeFromPod" => "0";
requires "Dist::Zilla::Plugin::ReadmeMarkdownFromPod" => "0";
requires "Dist::Zilla::Plugin::ReportVersions::Tiny" => "0";
requires "Dist::Zilla::Plugin::RunExtraTests" => "0";
requires "Dist::Zilla::Plugin::SchwartzRatio" => "0";
requires "Dist::Zilla::Plugin::Signature" => "0";
requires "Dist::Zilla::Plugin::Test::Compile" => "2.033";
requires "Dist::Zilla::Plugin::Test::UnusedVars" => "0";
requires "Dist::Zilla::Plugin::Twitter" => "0.025";
requires "Dist::Zilla::Plugin::VerifyPhases" => "0";
requires "Dist::Zilla::Role::AfterRelease" => "0";
requires "Dist::Zilla::Role::FileMunger" => "0";
requires "Dist::Zilla::Role::MintingProfile::ShareDir" => "0";
requires "Dist::Zilla::Role::PluginBundle::Config::Slicer" => "0";
requires "Dist::Zilla::Role::PluginBundle::Easy" => "0";
requires "Dist::Zilla::Role::TextTemplate" => "0";
requires "Dist::Zilla::Role::VersionProvider" => "0";
requires "Git::Repository" => "0";
requires "Moose" => "0";
requires "Perl::Version" => "0";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "File::Spec" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::More" => "0.88";
  requires "perl" => "5.006";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::ShareDir::Install" => "0.06";
};

on 'develop' => sub {
  requires "version" => "0.9901";
};
