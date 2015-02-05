#!/bin/bash

# Installation specifc (i.e. things you might want to change)
DOCBOOK_DIR=~/git/cf-convention.github.io/Data/cf-conventions/cf-conventions-1.7/docbooksrc
export CLASSPATH=~/saxon/saxon9he.jar

ROOT=cf-conventions.xml

STEP1_DIR=step1
STEP2_DIR=step2
STEP3_DIR=step3
STEP4_DIR=step4
mkdir -p $STEP1_DIR
mkdir -p $STEP2_DIR
mkdir -p $STEP3_DIR
mkdir -p $STEP4_DIR

if [[ $DOCBOOK_DIR/$ROOT -nt $STEP1_DIR/$ROOT ]]; then
    echo 'Stripping DOCTYPE'
    echo '================='
    # Saxon needs version of the DocBook files which have had their
    # DOCTYPE removed. Otherwise we get "Scanner State 24 not Recognized".
    rm -f $STEP1_DIR/*.xml
    python strip_doctype.py $DOCBOOK_DIR $STEP1_DIR
    cp $DOCBOOK_DIR/$ROOT $STEP1_DIR/
fi

if [[ $STEP1_DIR/$ROOT -nt $STEP2_DIR/$ROOT ||
      prepare_docbook.xsl -nt $STEP2_DIR/cf-conventions.xml ]]; then
    echo 'Preparing DocBook'
    echo '================='
    rm -f $STEP2_DIR/*.xml
    python prepare_docbook.py $STEP1_DIR $STEP2_DIR
fi

if [[ $STEP2_DIR/$ROOT -nt $STEP3_DIR/cf-conventions.asciidoc ||
      d2a.xsl -nt $STEP3_DIR/cf-conventions.asciidoc ]]; then
    echo 'Creating AsciiDoc'
    echo '================='
    rm -f $STEP3_DIR/*.asciidoc
    SRC_DOCBOOK=$STEP2_DIR/$ROOT
    STYLESHEET=d2a.xsl
    CHUNK='chunk-output=true'
    #CHUNK=''
    java net.sf.saxon.Transform -s:$SRC_DOCBOOK -xsl:$STYLESHEET -o:cf-conventions.asciidoc -t $CHUNK
    # TODO: Avoid shuffling files and just get Saxon to put the output
    # in the right place.
    mv *.asciidoc $STEP3_DIR/
    mv $STEP3_DIR/README* ./
    mv book-docinfo.xml $STEP3_DIR/
fi

CONVERT_TO_HTML=''
for f in $STEP3_DIR/*.asciidoc; do
    if [[ $f -nt $STEP4_DIR/cf-conventions.html ]]; then
        CONVERT_TO_HTML='true'
        break
    fi
done
if [[ $CONVERT_TO_HTML ]]; then
    echo 'Creating HTML'
    echo '============='
    rm -f $STEP4_DIR/*.html
    asciidoctor $STEP3_DIR/cf-conventions.asciidoc -D $STEP4_DIR
    #asciidoctor-pdf cf-conventions.asciidoc
fi
