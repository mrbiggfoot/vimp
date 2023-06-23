#!/bin/bash

if [ -z "$VIMP_PROJECTS_META_ROOT" ]; then
	PRJ_META_ROOT=~/projects/.meta
else
	PRJ_META_ROOT=$VIMP_PROJECTS_META_ROOT
fi

CUR_PRJ_META_ROOT=$PRJ_META_ROOT$(pwd)
CUR_PRJ_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

if [ -z "$CUR_PRJ_BRANCH" ]; then
	CUR_PRJ_BRANCH_META_ROOT=$CUR_PRJ_META_ROOT
else
	CUR_PRJ_BRANCH_META_ROOT=$CUR_PRJ_META_ROOT/$CUR_PRJ_BRANCH
fi

CUR_PRJ_SETTINGS=$CUR_PRJ_BRANCH_META_ROOT/project_settings.sh
CUR_PRJ_FILES=${CUR_PRJ_BRANCH_META_ROOT}/files
CUR_PRJ_CTAGS=${CUR_PRJ_BRANCH_META_ROOT}/tags
CUR_PRJ_TAGNAMES=${CUR_PRJ_BRANCH_META_ROOT}/tagnames

#SRC_COMPILE_CMDS=$(pwd)/build/compile_commands.json
#CUR_PRJ_COMPILE_CMDS=${CUR_PRJ_BRANCH_META_ROOT}/compile_commands.json

print_usage()
{
	echo
	echo "Usage: project_generate.sh [ options ]"
	echo "If none of the following is specified, update the current project's"
	echo "file list and tags."
	echo
	echo "  mkdir    : create the project's metadata directory."
	echo "  pwd      : print the project's metadata directory."
	echo "  edit     : run vim to edit the project settings."
	echo "  ctags    : generate Universal ctags."
	echo "  gtags    : generate GNU Global tags."
	echo "  tags     : generate Universal and GNU Global tags."
	echo "  clean    : delete metadata of all the dead branches."
	echo "  cleanall : delete metadata of all the branches except the current one."
	echo
	exit
}

write_project_settings()
{
	echo "# Script to be included by 'project_generate.sh'"
	echo
	echo "# Directories to be included"
	echo "PRJ_DIRS=("
	find . -maxdepth 1 ! -path "*/\.*" ! -path "*\~" ! -path "." -type d | sort | xargs -n1 basename | awk '{ print "\t\"" $0 "\"" }'
	echo ")"
	echo
	echo "# Default tags to be built on running 'project_generate.sh'"
	echo "# Possible values are: ctags, gtags, none, all"
	echo "PRJ_TAGS=ctags"
	echo
	echo "# Tags type to generate tag names from: ctags, gtags or none"
	echo "PRJ_TAG_NAMES=ctags"
	echo
	echo "# Number of parallel instances to use by pgtags/pglobal"
	echo "# 0 disables parallelizing and uses the regular gtags/global"
	echo "PRJ_GTAGS_NUM_INSTANCES=0"
	echo
	echo "# Make the argument string for ripgrep"
	echo "PRJ_DIRS_ARG="
	echo "for dir in \"\${PRJ_DIRS[@]}\""
	echo "do"
	echo -e "\tPRJ_DIRS_ARG+=\"\$dir \""
	echo "done"
	echo
	echo "# Directories to be excluded"
	echo "#PRJ_DIRS_EXCLUDE=("
	echo -e "#\t\"build/toolchain/include/boost\""
	echo "#)"
	echo
	echo "# Make the argument string for ripgrep"
	echo "PRJ_DIRS_EXCLUDE_ARG="
	echo "for dir in \"\${PRJ_DIRS_EXCLUDE[@]}\""
	echo "do"
	echo -e "\tPRJ_DIRS_EXCLUDE_ARG+=\"-g '!\$dir' \""
	echo "done"
	echo
	echo "# File types to include in the project"
	echo "PRJ_FILE_TYPES=(\"c\" \"cpp\" \"protobuf\" \"flatbuffers\" \"py\")"
	echo
	echo "# Make the argument string for ripgrep"
	echo "PRJ_FILE_TYPES_ARG="
	echo "for t in \"\${PRJ_FILE_TYPES[@]}\""
	echo "do"
	echo -e "\tPRJ_FILE_TYPES_ARG+=\"-t \$t \""
	echo "done"
}

generate_ctags()
{
	echo Generate ctags
	CTAGS_OPT="--tag-relative=yes --c++-kinds=+p --fields=+iaS --map-protobuf=+.client"
	ctags -o $CUR_PRJ_CTAGS $CTAGS_OPT -L $CUR_PRJ_FILES

	if [ "$PRJ_TAG_NAMES" == 'ctags' ]; then
		echo Generate tag names from ctags
		grep -a -v "^\!" $CUR_PRJ_CTAGS | awk '{ if (length($1) > 3) print $1 }' | grep -v "::\|\." | sort | uniq >$CUR_PRJ_TAGNAMES
	fi
}

generate_gtags()
{
	echo Generate gtags
	if [ "$PRJ_GTAGS_NUM_INSTANCES" -eq 0 ]; then
		GTAGSFORCECPP=1 gtags -i -t -f $CUR_PRJ_FILES $CUR_PRJ_BRANCH_META_ROOT

		if [ "$PRJ_TAG_NAMES" == 'gtags' ]; then
			echo Generate tag names from gtags
			GTAGSROOT=`pwd` GTAGSDBPATH="$CUR_PRJ_BRANCH_META_ROOT" global --print-all 4 | sort | uniq >$CUR_PRJ_TAGNAMES
		fi
	else
		GTAGSFORCECPP=1 pgtags -n $PRJ_GTAGS_NUM_INSTANCES -d $CUR_PRJ_BRANCH_META_ROOT $CUR_PRJ_FILES -i -t

		if [ "$PRJ_TAG_NAMES" == 'gtags' ]; then
			echo Generate tag names from gtags
			pglobal -n $PRJ_GTAGS_NUM_INSTANCES $CUR_PRJ_BRANCH_META_ROOT --print-all 4 | sort | uniq >$CUR_PRJ_TAGNAMES
		fi
	fi
}

if [ $# -eq 1 ]; then
	if [ -f $CUR_PRJ_SETTINGS ]; then
		source $CUR_PRJ_SETTINGS
	fi
	if [ "$1" == 'mkdir' ]; then
		echo Create project metadata dir:
		echo $CUR_PRJ_BRANCH_META_ROOT
		mkdir -p $CUR_PRJ_BRANCH_META_ROOT
		echo Project settings:
		if [ -f $CUR_PRJ_SETTINGS ]; then
			echo $CUR_PRJ_SETTINGS already exists.
		else
			write_project_settings > $CUR_PRJ_SETTINGS
			echo $CUR_PRJ_SETTINGS created, edit it if required.
		fi
	elif [ "$1" == 'pwd' ]; then
		if [ -d $CUR_PRJ_BRANCH_META_ROOT ]; then
			echo $CUR_PRJ_BRANCH_META_ROOT
		else
			echo Project dir $CUR_PRJ_BRANCH_META_ROOT does not exist! >&2
			exit 1
		fi
	elif [ "$1" == 'edit' ]; then
		vim $CUR_PRJ_SETTINGS
	elif [ "$1" == 'ctags' ]; then
		generate_ctags
	elif [ "$1" == 'gtags' ]; then
		generate_gtags
	elif [ "$1" == 'tags' ]; then
		generate_ctags
		generate_gtags
	elif [ "$1" == 'clean' ]; then
		echo Delete all dead branches
		for dir in `find $CUR_PRJ_META_ROOT -maxdepth 1 ! -path "$CUR_PRJ_BRANCH_META_ROOT" ! -path "$CUR_PRJ_META_ROOT" -type d -printf %f"\n"`
		do
			git branch | grep "$dir"
			if [ $? -ne 0 ]; then
				DELETE_BRANCH=$CUR_PRJ_META_ROOT/$dir
				echo Delete $DELETE_BRANCH
				rm -Rf $DELETE_BRANCH
			fi
		done
	elif [ "$1" == 'cleanall' ]; then
		echo Delete all branches metadata except the current one:
		echo $CUR_PRJ_BRANCH_META_ROOT
		find $CUR_PRJ_META_ROOT -maxdepth 1 ! -path "$CUR_PRJ_BRANCH_META_ROOT" ! -path "$CUR_PRJ_META_ROOT" -type d | xargs rm -Rf
	else
		print_usage
	fi
	exit
fi

if [ $# -ne 0 ]; then
	print_usage
fi

echo Create metadata in $CUR_PRJ_BRANCH_META_ROOT
mkdir -p $CUR_PRJ_BRANCH_META_ROOT

if [ ! -f $CUR_PRJ_SETTINGS ]; then
	write_project_settings | vim -c "file $CUR_PRJ_SETTINGS | set filetype=sh" -
fi

if [ ! -f $CUR_PRJ_SETTINGS ]; then
	echo No project settings $CUR_PRJ_SETTINGS
	echo Aborting
	exit
fi
source $CUR_PRJ_SETTINGS

# Generate list of project files
echo Generate list of project files
CMD="rg --follow --type-add 'protobuf:*.proto.client' $PRJ_FILE_TYPES_ARG $PRJ_DIRS_EXCLUDE_ARG --files $PRJ_DIRS_ARG 2> >(grep -v \"os error 2\" >&2) | sort > $CUR_PRJ_FILES"
eval $CMD

if [ "$PRJ_TAGS"  == 'ctags' ]; then
	generate_ctags
elif [ "$PRJ_TAGS" == 'gtags' ]; then
	generate_gtags
elif [ "$PRJ_TAGS" == 'all' ]; then
	generate_ctags
	generate_gtags
else
	echo Skip tags generation \(PRJ_TAGS is "$PRJ_TAGS"\)
fi
