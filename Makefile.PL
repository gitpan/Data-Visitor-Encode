# $Id: /mirror/perl/Data-Visitor-Encode/trunk/Makefile.PL 6215 2007-03-28T11:42:23.243798Z daisuke  $
#
# Copyright (c) 2006 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

use inc::Module::Install;

name 'Data-Visitor-Encode';
all_from 'lib/Data/Visitor/Encode.pm';
license 'perl';

requires 'Encode';
requires 'Data::Visitor';
requires 'Scalar::Util';
build_requires 'Test::More';

auto_install;
WriteAll;