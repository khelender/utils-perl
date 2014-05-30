#!perl.exe
#
#

$cleanupDir = "." ;
@searchDirs = ("\\") ;
if(@ARGV >= 2) {
	my($cleanupDir, @searchDir) = @ARGV ;
} elsif (@ARGV == 1) {
	$cleanupDir = shift(@ARGV);
} 


