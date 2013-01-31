#!/bin/bash
# 
# post-receive for staging server
# use with any bd or desby project
# @author frankrue@gmail.com
# 


# dynamic determination (maybe future use?)
############################################

# while read oldrev newrev refname
# do
#     branch=$(git rev-parse --symbolic --abbrev-ref $refname)
#     case "$branch" in
#
# 	    master)		# do stuff on production
# 	    			# because master is production
# 	    			echo You pushed for production.
# 	    			;;
#
# 	    develop)	# do stuff on staging
# 	    			# because develop is staging
# 	    			echo You pushed for staging.
# 	    			;;
#
# 	    *)			# other branches
# 	    			echo I have no idea what you\'re doing.
# 	    			;;
#
# 	esac
# done

# is this a bare repo?
if [ $(git rev-parse --is-bare-repository) = true ]
then
	# get the pwd
    REPOSITORY_BASENAME=$(basename "$PWD") 
else
	# get the parent dir
    REPOSITORY_BASENAME=$(basename $(readlink -nf "$PWD"/..))
fi
# remove the '.git' from the end
REPOSITORY_BASENAME=$(REPOSITORY_BASENAME%.git) 

# make a directory name
DIRECTORY=/var/www/$REPOSITORY_BASENAME
if [ ! -d "$DIRECTORY" ]; then
    mkdir $DIRECTORY
fi

# set the work tree to a folder in the www root
GIT_WORK_TREE=$DIRECTORY/

# checkout the files into the work tree
git checkout -f

# set the symlink for the config.php file
rm -f $DIRECTORY/inc/config.php
ln -s $DIRECTORY/inc/config.staging.php $DIRECTORY/inc/config.php

# create the version.txt in the root
git describe > $DIRECTORY/version.txt