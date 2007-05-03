# $Id: /mirror/perl/Data-Visitor-Encode/trunk/Makefile.PL 6628 2007-04-17T02:17:09.187313Z daisuke  $
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