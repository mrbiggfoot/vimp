#!/bin/bash

PRJ_META_ROOT=~/projects/.meta
CUR_PRJ_META_ROOT=$PRJ_META_ROOT$(pwd)
CUR_PRJ_SETTINGS=$CUR_PRJ_META_ROOT/project_settings.sh
CUR_PRJ_BRANCH_META_ROOT=$CUR_PRJ_META_ROOT/$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
CUR_PRJ_FILES=${CUR_PRJ_BRANCH_META_ROOT}/files
CUR_PRJ_CTAGS=${CUR_PRJ_BRANCH_META_ROOT}/tags
CUR_PRJ_TAGNAMES=${CUR_PRJ_BRANCH_META_ROOT}/tagnames

print_usage()
{
	echo
	echo "project_generate.sh [ mkdir | edit | gtags | clean | cleanall ]"
	echo "If none of the following is specified, update the current project's metadata."
	echo
	echo "  * If 'mkdir' is specified, creates the project's metadata directory."
	echo "  * If 'edit' is specified, runs vim to edit the project settings."
	echo "  * If 'gtags' is specified, generates GNU Global tags."
	echo "  * If 'clean' is specified, deletes metadata of all the dead branches."
	echo "  * If 'cleanall' is specified, deletes metadata of all the branches"
	echo "    except the current one."
	echo
	exit
}

write_project_settings()
{
	echo "# Script to be included by 'project_generate.sh'"
	echo
	echo "# Directories to be included"
	echo "PRJ_DIRS=("
	find . -maxdepth 1 ! -path "*/\.*" ! -path "*\~" ! -path "." -type d -printf "\t\"%f\"\n"
	echo ")"
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
	echo "PRJ_FILE_TYPES=(\"c\" \"cpp\" \"protobuf\" \"py\")"
	echo
	echo "# Make the argument string for ripgrep"
	echo "PRJ_FILE_TYPES_ARG="
	echo "for t in \"\${PRJ_FILE_TYPES[@]}\""
	echo "do"
	echo -e "\tPRJ_FILE_TYPES_ARG+=\"-t \$t \""
	echo "done"
}

generate_gtags()
{
	echo Generate gtags
	GTAGSFORCECPP=1 gtags -i -f $CUR_PRJ_FILES $CUR_PRJ_BRANCH_META_ROOT
}

if [ $# -eq 1 ]; then
	if [ "$1" == 'mkdir' ]; then
		echo Create project metadata dir:
		echo $CUR_PRJ_META_ROOT
		mkdir -p $CUR_PRJ_META_ROOT
		echo Project settings:
		if [ -f $CUR_PRJ_SETTINGS ]; then
			echo $CUR_PRJ_SETTINGS already exists.
		else
			write_project_settings > $CUR_PRJ_SETTINGS
			echo $CUR_PRJ_SETTINGS created, edit it if required.
		fi
	elif [ "$1" == 'edit' ]; then
		nvim $CUR_PRJ_SETTINGS
	elif [ "$1" == 'gtags' ]; then
		generate_gtags
	elif [ "$1" == 'cleanall' ]; then
		echo Delete all branches metadata except the current one:
		echo $CUR_PRJ_BRANCH_META_ROOT
		find $CUR_PRJ_META_ROOT -maxdepth 1 ! -path "$CUR_PRJ_BRANCH_META_ROOT" ! -path "$CUR_PRJ_META_ROOT" -type d | xargs rm -Rf
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

source $CUR_PRJ_SETTINGS

# Generate list of project files
echo Generate list of project files
CMD="rg --files $PRJ_FILE_TYPES_ARG $PRJ_DIRS_EXCLUDE_ARG $PRJ_DIRS_ARG | sort > $CUR_PRJ_FILES"
eval $CMD

# Generate ctags
echo Generate ctags
CTAGS_OPT="--tag-relative=yes --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python,vim,html,lua,javascript,java,protobuf,go"
ctags -o $CUR_PRJ_CTAGS $CTAGS_OPT -L $CUR_PRJ_FILES

# Generate tag names
echo Generate tag names
grep -v "^\!" $CUR_PRJ_CTAGS | awk '{ if (length($1) > 3) print $1 }' | grep -v "::" | sort | uniq >$CUR_PRJ_TAGNAMES
