#! /bin/sh
cat <<EOF
# SOME DESCRIPTIVE TITLE.
# Copyright (C) YEAR THE PACKAGE'S COPYRIGHT HOLDER
# This file is distributed under the same license as the PACKAGE package.
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
#
#, fuzzy
msgid ""
msgstr ""
"Project-Id-Version: PACKAGE VERSION\n"
"Report-Msgid-Bugs-To: \n"
EOF
echo '"POT-Creation-Date: '$(date +"%Y-%m-%d %H:%M%z")'\\n"'
cat <<EOF
"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n"
"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"
"Language-Team: LANGUAGE <LL@li.org>\n"
"Language: \n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=CHARSET\n"
"Content-Transfer-Encoding: 8bit\n"
"Plural-Forms: nplurals=INTEGER; plural=EXPRESSION;\n"

EOF
(
# find preload messages
grep -Hn 'message="[^"][^"]*"' data/preload.cfg | \
	sed -ne 's/^\(.*:[0-9]*\):.*message="/#: \1\n"/;s/"\([^"]*\)".*/msgid "\1"\nmsgstr ""\n/gp'
# find level titles
grep -Hn '^title="[^"][^"]*"' data/level/*.cfg | \
	sed -ne 's/^\(.*:[0-9]*\):title="/#: \1\n"/;s/"\([^"]*\)".*/msgid "\1"\nmsgstr ""\n/gp'
# find marked strings ~...~ in data files
grep -Hnr --exclude-dir=".svn" "~[^~][^~]*~" data/level/ data/objects/ data/object_prototypes/ | \
	sed -ne ":A;s/\([a-z0-9/\._-]*:[0-9]*\):[^~]*~\([^~][^~]*\)~/\n#: \1\nmsgid \"\2\"\nmsgstr \"\"\n\1:/;tA;s/\n\([a-z0-9/\._-]*:[0-9]*\):[^\n]*//;p"
# find marked strings _("...") in source files
grep -Hn '[^a-z]_("[^"]*")' src/*.cpp | \
	sed -ne 's/^\(.*:[0-9][0-9]*\):.*_("/#: \1\n_("/;s/_("\([^"]*\)").*\(_("\|\)/msgid "\1"\nmsgstr ""\n\2/gp'
) | msguniq -F -