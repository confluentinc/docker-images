%define name %NAME%
%define version %VERSION%
%define release %RELEASE%
%define buildroot %{_topdir}/BUILDROOT
%define sources %{_topdir}/SOURCES

BuildRoot: %{buildroot}
Source: %SOURCE%
Summary: %{name}
Name: %{name}
Version: %{version}
Release: %{release}
License: Apache License, Version 2.0
Group: System
AutoReqProv: no

%description
%{name}

%prep
mkdir -p %{buildroot}/etc/sysconfig
cp %{sources}/%{name}.sysconfig %{buildroot}/etc/sysconfig/%{name}

mkdir -p %{buildroot}/etc/systemd/system
cp %{sources}/%{name}.systemd %{buildroot}/etc/systemd/system/%{name}.service

%post
which systemctl &>/dev/null && systemctl daemon-reload

%files
%defattr(-,root,root)
%config(noreplace) /etc/sysconfig/%{name}
/etc/systemd/system/%{name}.service
