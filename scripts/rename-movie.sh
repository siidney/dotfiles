# script to format movie files
#!/bin/sh

# extract and store extension
get_extension(){
    local ext=${rawfile:(-4)}

    # account for extensions such as mpeg
    if [[ ${ext:0:1} != "." ]]
    then
        echo ".$ext"
    else
        echo "$ext"
    fi
}
# filename format entry point
format_file(){
    noext=$(drop_extension $1)

    bracketdate=$(bracket_date $noext)

    spaces=$(add_spaces $bracketdate)

    rename $spaces
}
# drop extension from rawfile
drop_extension(){
    echo ${rawfile%$extension}
}
# add brackets around date
bracket_date(){
    # check if filename contains date
    # if so bracket, if not return original string
    if [[ $1 =~ [0-9]{4} ]]
    then
        date=$BASH_REMATCH
        repl="[$date]"

        echo ${1/$date/$repl}
    else
        echo $1
    fi
}
# replaces . with spaces
add_spaces(){
    match="."
    repl=' '
    echo ${1//$match/$repl}
}
# append file extension and rename rawfile
rename(){
     formattedfile=$*$extension

     mv "$rawfile" "$formattedfile"

     # check exit code of mv
     if [ $? -eq 0 ]
     then
         echo "File rename successful."
     else
         echo "File rename error."
     fi
}
# get rawfile
if [ $# -eq 0 ]
then
    echo -e "\E[0,36mPlease input a media filename to be renamed: "
    read rawfile
else
    rawfile=$1
fi

# ensure file exists
if [[ -f "${rawfile:-no-such-file}" ]]
then
    extension=$(get_extension)
    format_file rawfile
else
    echo -e "\E[0,36mERROR: file not found!"
fi
