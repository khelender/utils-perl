#!d:\utils\perl\bin\perl.exe 

$cleanupDir = "." ;
@searchDirs = ("\\") ;
if(@ARGV >= 2) {
	my($cleanupDir, @searchDir) = @ARGV ;
} elsif (@ARGV == 1) {
	$cleanupDir = shift(@ARGV);
} 



$debug = 0;
$checkRedundancy = 0;
$info = 1 ;
$dirSeparator = "/" ;
@listPhotoFileExts = ("\.jpg" ) ;
$mediaCaptureBaseDir = "d:/data/data_family/sync_data_family_cloud/Dropbox/Camera Uploads" ;
$mediaPhotosBaseDir = "d:/data/data_family/sync_data_family_media/1_Photos/Photographs" ;
$logFile = $0 . ".log" ;

&logStartMessage();
@photoFiles = &getFilesInDir($mediaCaptureBaseDir, \@listPhotoFileExts ) ;
$debug && print "Files found :\n" .join( "\n", @photoFiles) . "\n" ;
&moveFiles($mediaCaptureBaseDir, $mediaPhotosBaseDir, \@photoFiles) ;

close(LOGFILE);

sub initLogFile() {
	open LOGFILE, ">>$logFile" || die "Can't open $logFile for writing !!\n";
	print LOGFILE "-" x 80 . "\n";
}


sub logStartMessage() {
	&logMessage("Starting script $0 with args @ARGV \n" );
}

sub logMessage() {
	print LOGFILE &getTimeStamp() . " @_ \n" ;
}

sub moveFiles
{
	my($srcDir, $destDir, $aRefFiles) = @_ ;
	my $moveCnt = 0 ;
	use File::Basename ;
	use File::Path ;
	use File::Copy 'move' ;

	foreach $file (@$aRefFiles) {
		$srcFile = $srcDir . $dirSeparator . $file ;
		&getDirectoryToMoveTo($srcFile);
		exit 1;
		#$destFile = 
		my(undef, $destDirPath) = fileparse($destDir . $dirSeparator . $file) ;
		$debug && print "Moving file $srcFile => $destFile \n" ;
		$debug && print "Need to have base directory $destDirPath \n" ;
		if( ! -e $destDirPath ) {
			if(!mkpath($destDirPath)) {
				warn "Can't create directory $destDirPath \n" ; 
				next ;
			}
		}
		next if( (! -e $destDirPath ) ||  (! -d _ )) ;

		if(move($srcFile, $destDirPath)) {
			$info && print "Moved $file \n" ;
			$moveCnt++ ;
		} else {
			warn "Can't move $srcFile -> $destDirPath (ERRNO $!) (LT $<) $ERRNO \n" ;
		}
	}
	print "Moved $moveCnt files \n" ;
}

sub getDirectoryToMoveTo($) {
	my($fileName) = @_ ;
	my @mTime = localtime((stat($fileName))[9]);
	my $dirName = sprintf("%s%s%04d%s%04d-%02d", $mediaPhotosBaseDir, $dirSeparator, $mTime[5]+1900, $dirSeparator,
				$mTime[5]+1900, $mTime[4]+ 1);
	print "Dir location for file $fileName is :\n $dirName \n" ;
}

sub getTimeStamp() {
	my @mTime = localtime(time());
	sprintf("%04d%02d%02d_%02d:%02d:%02d:%02d", $mTime[5]+1900, $mTime[4]+1, $mTime[3], $mTime[2], $mTime[1], $mTime[0]);
}

sub getFilesInDir
{
	local($baseDir, $arrRefFileExts) = @_;
	local(@targetFiles) = () ;
	use File::Find ;

	$pattern = join( '|', @$arrRefFileExts ) ;
	$debug && print "Using pattern $pattern for search in $baseDir \n" ;

	find( { wanted => sub { 
			return if( $_ !~ m/($pattern)$/i )  ;
			#push(@targetFiles, $_) ; 
			push(@targetFiles, $File::Find::name) ; 
			},
		no_chdir => 0 
	      },
	      $baseDir) ;
        map { s#^${baseDir}.## } @targetFiles ; # Last . is for directory separator
	@targetFiles ;
}

__END__ ;


	#use Cwd ; # 'abs_path' if required	# Not used now
	#use File::Glob  ':globally';	# Not used now
