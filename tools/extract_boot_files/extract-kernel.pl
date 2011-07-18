#!/usr/bin/perl -W

use strict;
use bytes;
use File::Path;

die "未指定 boot 镜像文件\n" unless $ARGV[0];

my $bootimgfile = $ARGV[0];

my $slurpvar = $/;
undef $/;
open (BOOTIMGFILE, "$bootimgfile") or die "无法打开 boot 镜像文件：$bootimgfile\n";
binmode(BOOTIMGFILE);
my $bootimg = <BOOTIMGFILE>;
close BOOTIMGFILE;
$/ = $slurpvar;


my($bootMagic, $kernelSize, $kernelLoadAddr, $ram1Size, $ram1LoadAddr, $ram2Size, $ram2LoadAddr, $tagsAddr, $pageSize, $unused1, $unused2, $bootName, $cmdLine, $id) =
	unpack('a8 L L L L L L L L L L a16 a512 a8', $bootimg);

$pageSize = 2048;
my($kernel) = substr($bootimg, $pageSize, $kernelSize);

open (KERNELFILE, ">zImage");
binmode(KERNELFILE);
print KERNELFILE $kernel or die;
close KERNELFILE;
