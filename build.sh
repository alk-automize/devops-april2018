#!/usr/bin/env bash


if [[ ! -d $1 && -z $1 ]] ; then
	echo "Usage: $0 <directory>"
	exit
fi

TEMPLATEDIR=$1

echo "# CLEANUP"
rm -rf $TEMPLATEDIR/work
rm -rf $TEMPLATEDIR/output

echo "# Make folders"
mkdir -p $TEMPLATEDIR/work
mkdir -p $TEMPLATEDIR/output

echo "# Convert Excel-spreadsheet to CSV"
xlsx2csv $TEMPLATEDIR/variables.xlsx $TEMPLATEDIR/work/variables.csv

echo "# Make one huge outputfile from template"
confplate -i $TEMPLATEDIR/work/variables.csv $TEMPLATEDIR/template.cfg > $TEMPLATEDIR/work/big-motherfscker-output.cfg

echo "# Split it into small files in output/"
awk -v "RS=[" -v TEMPLATEDIR=$TEMPLATEDIR -F " " 'NF != 0 {print "!!! [" $0 > TEMPLATEDIR "/output/" $1 ".cfg" }' $TEMPLATEDIR/work/big-motherfscker-output.cfg

echo "# CLEANUP"
rm -rf $TEMPLATEDIR/work

echo "# DONE \o/"
