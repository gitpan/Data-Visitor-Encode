# $Id: /mirror/coderepos/lang/perl/Data-Visitor-Encode/trunk/Makefile.PL 100930 2009-02-20T00:59:21.510113Z daisuke  $
#
# Copyright (c) 2006 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

use inc::Module::Install;

name 'Data-Visitor-Encode';
all_from 'lib/Data/Visitor/Encode.pm';

requires 'Any::Moose' => '0.04';
requires 'Encode';
requires 'Data::Visitor', 0.18;
requires 'Scalar::Util';
build_requires 'Test::More';

auto_install;
WriteAll;