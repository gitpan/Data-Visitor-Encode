# $Id: /mirror/coderepos/lang/perl/Data-Visitor-Encode/trunk/Makefile.PL 66664 2008-07-24T01:21:22.935374Z daisuke  $
#
# Copyright (c) 2006 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

use inc::Module::Install;

name 'Data-Visitor-Encode';
all_from 'lib/Data/Visitor/Encode.pm';

requires 'Encode';
requires 'Data::Visitor', 0.18;
requires 'Scalar::Util';
build_requires 'Test::More';

auto_install;
WriteAll;