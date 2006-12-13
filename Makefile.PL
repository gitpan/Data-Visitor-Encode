# $Id: /mirror/perl/Data-Visitor-Encode/trunk/Makefile.PL 4460 2006-12-13T10:17:16.290415Z daisuke  $
#
# Copyright (c) 2006 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

use inc::Module::Install;

name 'Data-Visitor-Encode';
all_from 'lib/Data/Visitor/Encode.pm';
license 'perl';

requires 'Encode';
requires 'Data::Visitor';
build_requires 'Test::More';

auto_install;
WriteAll;