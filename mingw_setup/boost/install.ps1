param(
    [string]$MINGW_ENV
)

$DIR = Split-Path $MyInvocation.MyCommand.Path

#################
# Include utils #
#################

. (Join-Path "$DIR\.." "utils.ps1")


############################
# Create working directory #
############################

$WORKING_DIR = Join-Path $MINGW_ENV temp\boost

mkdir $WORKING_DIR -force


###################
# Check for 7-Zip #
###################

$7z = Join-Path $MINGW_ENV "temp\7zip\7za.exe"

if (-Not (Get-Command $7z -errorAction SilentlyContinue))
{
    [Windows.Forms.MessageBox]::Show(
        “Could not find 7-Zip command line tool. Please follow the directions in the Readme.txt to resolve this problem.”, 
        “7-Zip not found”, 
        [Windows.Forms.MessageBoxButtons]::OK, 
        [Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}


####################
# Download archive #
####################

$REMOTE_DIR="http://downloads.sourceforge.net/project/boost/boost/1.51.0"

$ARCHIVE="boost_1_51_0.7z"

$DESTINATION = Join-Path $WORKING_DIR $ARCHIVE

if (-Not (Test-Path $DESTINATION)) {
    $CLIENT = New-Object System.Net.WebClient
    $CLIENT.DownloadFile("$REMOTE_DIR/$ARCHIVE", $DESTINATION)
}

##########
# Unpack #
##########

$ARGUMENTS = "x",
             "-y",
             "-o$WORKING_DIR",
             $DESTINATION
             
& $7z $ARGUMENTS


#############
# Bootstrap #
#############

pushd (Join-Path $WORKING_DIR "boost_1_51_0")

& .\bootstrap.bat


#############################################
# Create user config for boost build system #
#############################################

$MINGW_BIN_DIR = (Join-Path $MINGW_ENV bin).replace("\", "\\")

$USER_CONFIG = "
using gcc : 4.8 : $MINGW_BIN_DIR\\g++.exe
        :
        <rc>$MINGW_BIN_DIR\\windres.exe
        <archiver>$MINGW_BIN_DIR\\ar.exe
;
"

$USER_CONFIG_FILE = Join-Path $WORKING_DIR "user-config.jam"

Set-Content $USER_CONFIG_FILE $USER_CONFIG


#########
# Build #
#########

$ARGUMENTS  =
    "address-model=32",
    "toolset=gcc" ,
    "target-os=windows",
    "variant=release",
    "threading=multi",
    "threadapi=win32",
    "link=shared",
    "runtime-link=shared",
    "--prefix=$MINGW_ENV/install",
    "--user-config=$WORKING_DIR/user-config.jam",
    "--without-mpi",
    "--without-python",
    "-sNO_BZIP2=1",
    "-sNO_ZLIB=1",
    "--layout=tagged",
    "install"

& .\b2 $ARGUMENTS

popd