%global gemname hammer_cli_katello
%global confdir hammer

%if 0%{?rhel} < 7
%global gem_dir /usr/lib/ruby/gems/1.8
%endif

%global geminstdir %{gem_dir}/gems/%{gemname}-%{version}

Summary: Katello command plugin for the Hammer CLI
Name: rubygem-%{gemname}
Version: 0.0.6
Release: 1%{?dist}
Group: Development/Languages
License: GPLv3
URL: http://github.com/theforeman/hammer-cli-katello
Source0: %{gemname}-%{version}.gem
Source1: katello.yml

%if !( 0%{?rhel} > 6 || 0%{?fedora} > 18 )
Requires: ruby(abi)
%endif
Requires: ruby(rubygems)
Requires: rubygem(hammer_cli) >= 0.1.1
Requires: rubygem(hammer_cli_foreman_tasks) >= 0.0.3
BuildRequires: ruby(rubygems)
%if 0%{?fedora} || 0%{?rhel} > 6
BuildRequires: rubygems-devel
%endif
BuildRequires: ruby
BuildArch: noarch
Provides: rubygem(%{gemname}) = %{version}

%description
Katello command plugin for the Hammer CLI.


%package doc
Summary: Documentation for %{name}
Group: Documentation
Requires: %{name} = %{version}-%{release}
BuildArch: noarch

%description doc
Documentation for %{name}

%prep
%setup -q -c -T
mkdir -p .%{gem_dir}
gem install --local --install-dir .%{gem_dir} \
            --force %{SOURCE0}

%install
mkdir -p %{buildroot}%{_sysconfdir}/%{confdir}/cli.modules.d
install -m 755 %{SOURCE1} %{buildroot}%{_sysconfdir}/%{confdir}/cli.modules.d/katello.yml
mkdir -p %{buildroot}%{gem_dir}
cp -pa .%{gem_dir}/* \
        %{buildroot}%{gem_dir}/

%files
%dir %{geminstdir}
%{geminstdir}/lib
%{geminstdir}/locale
%config(noreplace) %{_sysconfdir}/%{confdir}/cli.modules.d/katello.yml
%exclude %{gem_dir}/cache/%{gemname}-%{version}.gem
%{gem_dir}/specifications/%{gemname}-%{version}.gemspec

%files doc
%doc %{gem_dir}/doc/%{gemname}-%{version}

%changelog
* Wed Jun 11 2014 Jason Montleon <jmontleo@redhat.com> 0.0.4-6
- Fixes #6096 - override sub --system-id description (dtsang@redhat.com)
- Fixes #6071 - override CH --id desc (dtsang@redhat.com)
- Fixes #6056 - HC override desc create/update sysid (dtsang@redhat.com)
- Fixes #6055 - HC add/remove-content-host take uuid (dtsang@redhat.com)
- Fixes #5794 : Improve how Async commands are done in katello-cli.
  (bkearney@redhat.com)
- Fixes #6101 - lfenv conditional resolv prior (dtsang@redhat.com)
- Fixes #6079, bz 1103958 - Display org name of a capsule env (paji@redhat.com)

* Tue Jun 03 2014 Jason Montleon <jmontleo@redhat.com> 0.0.4-5
- Fixes #5802 HC update/create using system uuids (dtsang@redhat.com)

* Wed May 28 2014 Jason Montleon <jmontleo@redhat.com> 0.0.4-4
- correct hammer_cli_foreman_tasks dependency version (jmontleo@redhat.com)

* Wed May 28 2014 Jason Montleon <jmontleo@redhat.com> 0.0.4-3
- update dependencies in rpm spec for 0.1.1 (jmontleo@redhat.com)

* Wed May 28 2014 Jason Montleon <jmontleo@redhat.com> 0.0.4-2
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Merge pull request #175 from komidore64/version-bump (komidore64@gmail.com)
- Merge pull request #176 from dustint-rh/product_info_content
  (dtsang@redhat.com)
- Fixes #5893 - Fixes product info's content (dtsang@redhat.com)
- bump to version 0.0.4 (komidore64@gmail.com)

* Wed May 28 2014 Jason Montleon <jmontleo@redhat.com> 0.0.4-1
- update version to 0.0.4 (jmontleo@redhat.com)

* Thu May 22 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-26
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Merge pull request #173 from iNecas/capsule (jlsherrill@gmail.com)
- Refs #5821 - address PR issues (inecas@redhat.com)
- Refs #5821 - initial CLI support for the capsule commands (inecas@redhat.com)

* Thu May 22 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-25
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Merge pull request #172 from bbuckingham/issue-5771 (bbuckingham@redhat.com)
- Merge pull request #168 from dustint-
  rh/985393_searchables_resolve_by_uuid_only_uuid (dtsang@redhat.com)
- update releasers (jmontleo@redhat.com)
- Fixes #5111 - product info did list options (dtsang@redhat.com)
- Merge pull request #164 from bkearney/bkearney/string_extract
  (komidore64@gmail.com)
- fixes #5771 - lifecycle-environment - fix the behavir of prior environment
  (bbuckingham@redhat.com)
- Fixes #5729 - content-host lookup by uuid (dtsang@redhat.com)
- Fixes #5658 - Latest String Extract (bkearney@redhat.com)

* Sat May 17 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-24
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- fixes #5598 - hammer cannot list repositories, BZ1094493
  (komidore64@gmail.com)
- Merge pull request #159 from bkearney/bkearney/5597 (bryan.kearney@gmail.com)
- Fixes #5613 - Content Hosts outputs uuid bz1084722 (dtsang@redhat.com)
- Merge pull request #163 from bbuckingham/issue-5601 (bbuckingham@redhat.com)
- Merge pull request #162 from bbuckingham/issue-5602 (bbuckingham@redhat.com)
- fixes #5601, #5603 - host-collections: add support for update and add/remove-
  content-host (bbuckingham@redhat.com)
- Merge pull request #155 from komidore64/rmi5028 (komidore64@gmail.com)
- Merge pull request #161 from bbuckingham/issue-5600 (bbuckingham@redhat.com)
- Merge pull request #160 from dustint-rh/update_readme_with_tasks
  (dtsang@redhat.com)
- fixes #5602 - host-collections: add command to list content-hosts
  (bbuckingham@redhat.com)
- fixes #5600 - fix host-collection copy command (bbuckingham@redhat.com)
- update README to also pull down hammer-cli-foreman-tasks (dtsang@redhat.com)
- Fixes #5597 - Exposes new data in the repository-set info command
  (bkearney@redhat.com)
- refs #5028 - organizations aren't a special case anymore
  (komidore64@gmail.com)

* Wed May 14 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-23
- fixes #5600 - fix host-collection copy command (bbuckingham@redhat.com)
- refs #5028 - organizations aren't a special case anymore
  (komidore64@gmail.com)

* Thu May 08 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-22
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Merge pull request #158 from bbuckingham/issue-5192 (bbuckingham@redhat.com)
- fixes #5192 - rename system-group to host-collection (bbuckingham@redhat.com)

* Wed May 07 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-21
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Merge pull request #157 from iNecas/repository-set-available
  (inecas@redhat.com)
- Merge pull request #152 from dustint-
  rh/bz1077893_redmine_5008_add_manifest_history (dtsang@redhat.com)
- Fixes #5569 - support --name for repository-set available-repositories
  (inecas@redhat.com)
- Refs #5008 adds manifest history to subscriptions and organization
  (dtsang@redhat.com)

* Tue May 06 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-20
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Merge pull request #156 from dustint-
  rh/bz985393_redmine5432_add_system_group_delete_command (dtsang@redhat.com)
- Fixed #5546 system_group info missing Total System (dtsang@redhat.com)
- Fixes #5432 adding system group delete command (dtsang@redhat.com)
- Merge pull request #153 from komidore64/rmi4919 (komidore64@gmail.com)
- Fixes #5199 - Add env and cv to output columns to Activation Key list command
  (dtsang@redhat.com)
- fixes #4919 - hammer systemgroup info has NO params, BZ1080475
  (komidore64@gmail.com)
- Refs #4311 - removing old scoped names functionality (tstrachota@redhat.com)
- refs #4311 - including `label` for organization lookup (komidore64@gmail.com)
- refs #4311 - making rubocop happy (komidore64@gmail.com)
- removed log_api_calls setting (tstrachota@redhat.com)
- fix in String#format (tstrachota@redhat.com)
- Refs #4311 - read and write commands merged (tstrachota@redhat.com)
- exception handler - process foreman style messages (tstrachota@redhat.com)
- Refs #4311 - searchables, id resolver and option builders
  (tstrachota@redhat.com)

* Mon May 05 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-19
- fix macros to work with RHEL 7 (jmontleo@redhat.com)

* Wed Apr 30 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-18
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Merge pull request #150 from komidore64/rubocop (komidore64@gmail.com)
- fixes #5462 - adding some rubocop directives (komidore64@gmail.com)
- Merge pull request #105 from bkearney/bkearney/zanata
  (bryan.kearney@gmail.com)
- Merge pull request #143 from iNecas/reposet-enable (inecas@redhat.com)
- Merge pull request #147 from daviddavis/temp/20140423175044
  (daviddavis@redhat.com)
- Fixes #5433 - Display redhat repo url (paji@redhat.com)
- Fixes #5420 - Fixes bad grammar message (daviddavis@redhat.com)
- Fixes #5415 - Fixed problems with cv destroy commands (daviddavis@redhat.com)
- Refs #4826 - Update cli to support new reposet approach (inecas@redhat.com)
- Add zanata translation information (bkearney@redhat.com)

* Wed Apr 23 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-17
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- fixes #5182 - Rename Systems to Content Hosts (bbuckingham@redhat.com)

* Thu Apr 17 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-16
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Merge pull request #141 from daviddavis/cvv_deletion (daviddavis@redhat.com)
- Refs #4811 - Allow users to delete content views from CLI
  (daviddavis@redhat.com)
- Merge pull request #134 from komidore64/bz1078866 (komidore64@gmail.com)
- Fixes #5135 BZ 1085541; removed duplicate output. (omaciel@ogmaciel.com)
- Refs #4957 - Allow users to delete content view versions
  (daviddavis@redhat.com)
- Merge pull request #132 from daviddavis/temp/20140402123025
  (daviddavis@redhat.com)
- Merge pull request #140 from daviddavis/cve-deletion (daviddavis@redhat.com)
- Merge pull request #136 from daviddavis/temp/20140405071614
  (daviddavis@redhat.com)
- Fixes #5048 - Fixing help text for composite option (daviddavis@redhat.com)
- Fixes #5092 - Updating README with new config structure
  (daviddavis@redhat.com)
- Refs #4818 - Allow users to remove a content view from environment
  (daviddavis@redhat.com)
- Fixes #5070 - Disabling name for associate commands (daviddavis@redhat.com)
- Fixes #5032 - hammer organization <info,list> --help types information
  doubled, 1078866 (komidore64@gmail.com)

* Thu Apr 03 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-15
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Fixes #4984, #5001, #5010 - Repo enable/disable (paji@redhat.com)

* Wed Apr 02 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-14
- Merge remote-tracking branch 'upstream/master' into SATELLITE-6.0.3
  (jmontleo@redhat.com)
- Merge pull request #122 from bkearney/bkearney/more-product-changes
  (komidore64@gmail.com)
- Merge pull request #128 from parthaa/good-bye-provider (komidore64@gmail.com)
- Fixes #4295 - Removing provider subcommands (paji@redhat.com)
- Fixes #4908 - Address provider and reposet usage testing
  (bkearney@redhat.com)

* Tue Apr 01 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-13
- Merge remote-tracking branch 'upstream/master' (jmontleo@redhat.com)
- Merge pull request #129 from parthaa/repo-crud (daviddavis@redhat.com)
- Fixes #4798 - Subscriptions and system groups for activation keys
  (thomasmckay@redhat.com)
- Fixes #4936 - Added repo info, update, delete ops (paji@redhat.com)

* Mon Mar 31 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-12
- Merge remote-tracking branch 'upstream/master' (jmontleo@redhat.com)
- Fixes #4953 - Show sync plan description (daviddavis@redhat.com)
- Merge pull request #127 from bkearney/bkearney/sync-plan-changes
  (bryan.kearney@gmail.com)
- Changes to sync plan based on usage. (bkearney@redhat.com)

* Thu Mar 27 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-11
- update confdir (jmontleo@redhat.com)

* Thu Mar 27 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-10
- update yml config location (jmontleo@redhat.com)

* Wed Mar 26 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-9
- Merge remote-tracking branch 'upstream/master' (jmontleo@redhat.com)
- Merge pull request #123 from daviddavis/temp/20140325083248
  (daviddavis@redhat.com)
- Merge remote-tracking branch 'upstream/master' (jmontleo@redhat.com)
- fixes #4885 - updated hammer-cli-katello deps (komidore64@gmail.com)
- Fixes #4837 - Adding i18n to strings (daviddavis@redhat.com)

* Wed Mar 26 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-8
- update rpm spec file to match upstream and add katello.yml config
  (jmontleo@redhat.com)
- update hammer_cli_foreman dependency (jmontleo@redhat.com)

* Wed Mar 26 2014 Jason Montleon <jmontleo@redhat.com>
- update rpm spec file to match upstream and add katello.yml config
  (jmontleo@redhat.com)
- update hammer_cli_foreman dependency (jmontleo@redhat.com)

* Wed Mar 26 2014 Jason Montleon <jmontleo@redhat.com>
- update rpm spec file to match upstream and add katello.yml config
  (jmontleo@redhat.com)
- update hammer_cli_foreman dependency (jmontleo@redhat.com)

* Wed Mar 26 2014 Jason Montleon <jmontleo@redhat.com>
- update rpm spec file to match upstream and add katello.yml config
  (jmontleo@redhat.com)
- update hammer_cli_foreman dependency (jmontleo@redhat.com)

* Wed Mar 26 2014 Jason Montleon <jmontleo@redhat.com>
- update rpm spec file to match upstream and add katello.yml config
  (jmontleo@redhat.com)
- update hammer_cli_foreman dependency (jmontleo@redhat.com)

* Wed Mar 26 2014 Jason Montleon <jmontleo@redhat.com>
- update rpm spec file to match upstream and add katello.yml config
  (jmontleo@redhat.com)
- update hammer_cli_foreman dependency (jmontleo@redhat.com)

* Wed Mar 26 2014 Jason Montleon <jmontleo@redhat.com>
- update rpm spec file to match upstream and add katello.yml config
  (jmontleo@redhat.com)
- update hammer_cli_foreman dependency (jmontleo@redhat.com)

* Tue Feb 04 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-1
- update hammer_cli_katello to 0.0.3 (jmontleo@redhat.com)

* Thu Jan 30 2014 Jason Montleon <jmontleo@redhat.com> 0.0.2-4
- add missing katello_api dependency (jmontleo@redhat.com)

* Mon Jan 27 2014 Jason Montleon <jmontleo@redhat.com> 0.0.2-3
- fix packaging error (jmontleo@redhat.com)

* Mon Jan 27 2014 Jason Montleon <jmontleo@redhat.com> 0.0.2-2
- new package built with tito

