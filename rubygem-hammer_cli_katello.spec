%global gemname hammer_cli_katello

%if 0%{?rhel}
%global gem_dir /usr/lib/ruby/gems/1.8
%endif

%global geminstdir %{gem_dir}/gems/%{gemname}-%{version}

Summary: Katello command plugin for the Hammer CLI
Name: rubygem-%{gemname}
Version: 0.0.3
Release: 1%{?dist}
Group: Development/Languages
License: GPLv3
URL: http://github.com/theforeman/hammer-cli-katello
Source0: %{gemname}-%{version}.gem

%if 0%{?rhel} == 6 || 0%{?fedora} < 19
Requires: ruby(abi)
%endif
Requires: ruby(rubygems)
Requires: rubygem(hammer_cli)
Requires: rubygem(katello_api)
BuildRequires: ruby(rubygems)
%if 0%{?fedora}
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
mkdir -p %{buildroot}%{gem_dir}
cp -pa .%{gem_dir}/* \
        %{buildroot}%{gem_dir}/

%files
%dir %{geminstdir}
%{geminstdir}/lib
%exclude %{gem_dir}/cache/%{gemname}-%{version}.gem
%{gem_dir}/specifications/%{gemname}-%{version}.gemspec

%files doc
%doc %{gem_dir}/doc/%{gemname}-%{version}

%changelog
* Tue Feb 04 2014 Jason Montleon <jmontleo@redhat.com> 0.0.3-1
- update hammer_cli_katello to 0.0.3 (jmontleo@redhat.com)

* Thu Jan 30 2014 Jason Montleon <jmontleo@redhat.com> 0.0.2-4
- add missing katello_api dependency (jmontleo@redhat.com)

* Mon Jan 27 2014 Jason Montleon <jmontleo@redhat.com> 0.0.2-3
- fix packaging error (jmontleo@redhat.com)

* Mon Jan 27 2014 Jason Montleon <jmontleo@redhat.com> 0.0.2-2
- new package built with tito

