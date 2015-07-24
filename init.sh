#!/bin/bash
ROOT=`pwd`

# mkdirs
cd $ROOT
mkdir server public client lib

# clients dirs
cd $ROOT/client
mkdir lib stylesheets templates

# server dirs
cd $ROOT/server

# public dirs
cd $ROOT/public
mkdir font icon img