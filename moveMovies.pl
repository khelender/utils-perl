#!d:\utils\perl\bin\perl.exe 
# **********************************************************************
# $Header$
# 
# $Author$
#
# $Log$
#
# **********************************************************************


$debug = 0;
$info = 1 ;
$dirSeparator = "/" ;
@listMovFileExts = ("\.mov", "\.avi", "\.mpg", "\.mp4", "\.mts" ) ;
$mediaCaptureBaseDir = "d:/data/sync_data_media_personal/WindowsMediaPictures" ;
$mediaMoviesBaseDir = "d:/data/sync_data_media_personal/Videos" ;

@movieFiles = &getFilesInDir($mediaCaptureBaseDir, \@listMovFileExts) ;
$debug && print "Files found :\n" .join( "\n", @movieFiles) . "\n" ;
&moveFiles($mediaCaptureBaseDir, $mediaMoviesBaseDir, \@movieFiles) ;


sub moveFiles
{
	my($srcDir, $destDir, $aRefFiles) = @_ ;
	my $moveCnt = 0 ;
	use File::Basename ;
	use File::Path ;
	use File::Copy 'move' ;

	foreach $file (@$aRefFiles) {
		$srcFile = $srcDir . $dirSeparator . $file ;
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
