#!/bin/bash

PRJ_META_ROOT=~/projects/.meta
CUR_PRJ_META_ROOT=$PRJ_META_ROOT$(pwd)
CUR_PRJ_SETTINGS=$CUR_PRJ_META_ROOT/project_settings.sh
CUR_PRJ_BRANCH_META_ROOT=$CUR_PRJ_META_ROOT/$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
CUR_PRJ_FILES=${CUR_PRJ_BRANCH_META_ROOT}/files
CUR_PRJ_FILES0=${CUR_PRJ_BRANCH_META_ROOT}/files0
CUR_PRJ_CTAGS=${CUR_PRJ_BRANCH_META_ROOT}/tags
CUR_PRJ_LANG_MAP=${CUR_PRJ_BRANCH_META_ROOT}/lang_map
CUR_PRJ_IDS=${CUR_PRJ_BRANCH_META_ROOT}/ID

print_usage()
{
	echo
	echo "project_generate.sh [ mkdir | gtags | clean | cleanall ]"
	echo "If none of the following is specified, update the current project's metadata."
	echo
	echo "  * If 'mkdir' is specified, creates the project's metadata directory."
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
	echo "# Directories to be excluded"
	echo "#PRJ_DIRS_EXCLUDE=("
	echo -e "#\t\"build/toolchain/include/boost\""
	echo "#)"
	echo
	echo "# File extensions to include in the project"
	echo "PRJ_FILE_FILTER=\"c|C|c\+\+|cc|cp|cpp|cxx|h|H|h\+\+|hh|hp|hpp|hxx|inl|ipp|\"\\"
	echo "\"proto|py\""
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
FIND_DIRS=
for dir in "${PRJ_DIRS[@]}"
do
	FIND_DIRS+="$dir "
done

FIND_DIRS_EXCLUDE=
for dir in "${PRJ_DIRS_EXCLUDE[@]}"
do
	FIND_DIRS_EXCLUDE+=" -not \( -path $dir -prune \)"
done

CMD="find $FIND_DIRS $FIND_DIRS_EXCLUDE -regextype posix-extended -regex \".*\.($PRJ_FILE_FILTER)\" > $CUR_PRJ_FILES"
eval $CMD

# Generate IDs
echo Generate IDs
cat $CUR_PRJ_FILES | tr '\n' '\0' > $CUR_PRJ_FILES0

write_lang_map()
{
	echo "*.c     text"
	echo "*.C     text"
	echo "*.c++   text"
	echo "*.cc    text"
	echo "*.cp    text"
	echo "*.cpp   text"
	echo "*.cxx   text"
	echo "*.h     text"
	echo "*.H     text"
	echo "*.h++   text"
	echo "*.hh    text"
	echo "*.hp    text"
	echo "*.hpp   text"
	echo "*.hxx   text"
	echo "*.inl   text"
	echo "*.ipp   text"
	echo "*.proto text"
	echo "*.py    text"
}
write_lang_map > $CUR_PRJ_LANG_MAP
mkid --include="text" --default-lang="text" --lang-map=$CUR_PRJ_LANG_MAP --files0-from=$CUR_PRJ_FILES0 --output=$CUR_PRJ_IDS
rm -f $CUR_PRJ_FILES0 $CUR_PRJ_LANG_MAP

# Generate ctags
echo Generate ctags
CTAGS_OPT="--tag-relative=yes --c++-kinds=+p --fields=+iaS --extra=+q --languages=c,c++,c#,python,vim,html,lua,javascript,java,protobuf --langmap=c++:+.inl,c:+.fx,c:+.fxh,c:+.hlsl,c:+.vsh,c:+.psh,c:+.cg,c:+.shd,javascript:+.as"
ctags -o $CUR_PRJ_CTAGS $CTAGS_OPT -L $CUR_PRJ_FILES
