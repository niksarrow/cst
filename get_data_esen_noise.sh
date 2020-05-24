# Nikhil Saini
# 17 Feb 2020 19:03

set -e

#
# Data preprocessing configuration
#

N_MONO=87220  # number of monolingual sentences for each language
CODES=50000      # number of BPE codes
N_THREADS=35     # number of threads in data preprocessing
N_EPOCHS=10      # number of fastText epochs


#
# Initialize tools and data paths
#

# main paths
UMT_PATH=$PWD
TOOLS_PATH=$PWD/tools
DATA_PATH=$PWD/data/noise1
MONO_PATH=$DATA_PATH/mono
MONO_PATH_EN=$DATA_PATH/mono_en
MONO_PATH_ES=$DATA_PATH/mono_es
PARA_PATH=$DATA_PATH/para
PARA_AUX_PATH=$DATA_PATH/para_aux
EVAL_PATH=$DATA_PATH

# create paths
mkdir -p $TOOLS_PATH
mkdir -p $DATA_PATH
mkdir -p $MONO_PATH
mkdir -p $MONO_PATH_EN
mkdir -p $MONO_PATH_ES
mkdir -p $PARA_PATH
mkdir -p $PARA_AUX_PATH
mkdir -p $EVAL_PATH

# moses
MOSES=$TOOLS_PATH/mosesdecoder
TOKENIZER=$MOSES/scripts/tokenizer/tokenizer.perl
NORM_PUNC=$MOSES/scripts/tokenizer/normalize-punctuation.perl
INPUT_FROM_SGM=$MOSES/scripts/ems/support/input-from-sgm.perl
REM_NON_PRINT_CHAR=$MOSES/scripts/tokenizer/remove-non-printing-char.perl

# fastBPE
FASTBPE_DIR=$TOOLS_PATH/fastBPE
FASTBPE=$FASTBPE_DIR/fast

# fastText
FASTTEXT_DIR=$TOOLS_PATH/fastText
FASTTEXT=$FASTTEXT_DIR/fasttext

# files full paths
SRC_RAW=$MONO_PATH/all.es
TGT_RAW=$MONO_PATH/all.en
SRC_TOK=$MONO_PATH/all.es.tok
TGT_TOK=$MONO_PATH/all.en.tok

SRC_RAW_EN=$MONO_PATH_EN/all.en.disfluent
TGT_RAW_EN=$MONO_PATH_EN/all.en
SRC_TOK_EN=$MONO_PATH_EN/all.en.disfluent.tok
TGT_TOK_EN=$MONO_PATH_EN/all.en.tok

SRC_RAW_ES=$MONO_PATH_ES/all.es.disfluent
TGT_RAW_ES=$MONO_PATH_ES/all.es
SRC_TOK_ES=$MONO_PATH_ES/all.es.disfluent.tok
TGT_TOK_ES=$MONO_PATH_ES/all.es.tok

BPE_CODES=$MONO_PATH/bpe_codes
CONCAT_BPE=$MONO_PATH/all.es-en.$CODES
SRC_VOCAB=$MONO_PATH/vocab.es.$CODES
TGT_VOCAB=$MONO_PATH/vocab.en.$CODES
FULL_VOCAB=$MONO_PATH/vocab.es-en.$CODES

SRC_TRAIN=$PARA_PATH/dev/train.es
TGT_TRAIN=$PARA_PATH/dev/train.en
SRC_VALID=$PARA_PATH/dev/tun.es
TGT_VALID=$PARA_PATH/dev/tun.en
SRC_TEST=$PARA_PATH/dev/test.es
TGT_TEST=$PARA_PATH/dev/test.en

SRC_TRAIN_AUX=$PARA_AUX_PATH/dev/train.es
TGT_TRAIN_AUX=$PARA_AUX_PATH/dev/train.en

SUB_SRC=$EVAL_PATH/sub4/tun.es
SUB_TGT=$EVAL_PATH/sub4/tun.en

CONCAT_SRC=$MONO_PATH/CONCAT_SRC
CONCAT_TGT=$MONO_PATH/CONCAT_TGT
#
# Download and install tools
#

# Download Moses
cd $TOOLS_PATH
if [ ! -d "$MOSES" ]; then
    echo "Cloning Moses from GitHub repository..."
    git clone https://github.com/moses-smt/mosesdecoder.git
fi
echo "Moses found in: $MOSES"

# Download fastBPE
cd $TOOLS_PATH
if [ ! -d "$FASTBPE_DIR" ]; then
    echo "Cloning fastBPE from GitHub repository..."
    git clone https://github.com/glample/fastBPE
fi
echo "fastBPE found in: $FASTBPE_DIR"

# Compile fastBPE
cd $TOOLS_PATH
if [ ! -f "$FASTBPE" ]; then
  echo "Compiling fastBPE..."
  cd $FASTBPE_DIR
  g++ -std=c++11 -pthread -O3 fast.cc -o fast
fi
echo "fastBPE compiled in: $FASTBPE"

# Download fastText
cd $TOOLS_PATH
if [ ! -d "$FASTTEXT_DIR" ]; then
    echo "Cloning fastText from GitHub repository..."
    git clone https://github.com/facebookresearch/fastText.git
fi
echo "fastText found in: $FASTTEXT_DIR"

# Compile fastText
cd $TOOLS_PATH
if [ ! -f "$FASTTEXT" ]; then
  echo "Compiling fastText..."
  cd $FASTTEXT_DIR
  make
fi
echo "fastText compiled in: $FASTTEXT"

#
# Download monolingual data
#
cd $EVAL_PATH/sub4
echo " submission data tokenizing"
cat $SUB_SRC | $NORM_PUNC -l es | $REM_NON_PRINT_CHAR | $TOKENIZER -l es -no-escape -threads $N_THREADS > $SUB_SRC.n
cat $SUB_TGT | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $SUB_TGT.n

echo "applying bpe"
$FASTBPE applybpe $SUB_SRC.$CODES $SUB_SRC.n $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $SUB_TGT.$CODES $SUB_TGT.n $BPE_CODES $TGT_VOCAB

echo "binarizing"

$UMT_PATH/preprocess.py $FULL_VOCAB $SUB_SRC.$CODES
$UMT_PATH/preprocess.py $FULL_VOCAB $SUB_TGT.$CODES

exit

$MONO_PATH
echo "Monolingual Spanish Data (unconstrained) setup"

echo "Monolingual English Data(unconstrained) setup"
echo "Es monolingual data concatenated in: $SRC_RAW"
echo "En monolingual data concatenated in: $TGT_RAW"

# check number of lines
if ! [[ "$(wc -l < $SRC_RAW)" -eq "$N_MONO" ]]; then echo "ERROR: Number of lines doesn't match! Be sure you have $N_MONO sentences in your EN monolingual data."; exit; fi
if ! [[ "$(wc -l < $TGT_RAW)" -eq "$N_MONO" ]]; then echo "ERROR: Number of lines doesn't match! Be sure you have $N_MONO sentences in your FR monolingual data."; exit; fi

# tokenize data
if ! [[ -f "$SRC_TOK" && -f "$TGT_TOK" ]]; then
  echo "Tokenize monolingual data..."
  cat $SRC_RAW | $NORM_PUNC -l es | $TOKENIZER -l es -no-escape -threads $N_THREADS > $SRC_TOK
  cat $TGT_RAW | $NORM_PUNC -l en | $TOKENIZER -l en -no-escape -threads $N_THREADS > $TGT_TOK
fi
echo "Es monolingual data tokenized in: $SRC_TOK"
echo "En monolingual data tokenized in: $TGT_TOK"

cd $PARA_PATH

echo "Parallel Fisher Data (Spanish Disfluent ASR Output || English Disfluent Translations) setup"

echo "Tokenizing valid and test data..."
cat $SRC_VALID | $NORM_PUNC -l es | $REM_NON_PRINT_CHAR | $TOKENIZER -l es -no-escape -threads $N_THREADS > $SRC_VALID.n
cat $TGT_VALID | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $TGT_VALID.n
cat $SRC_TEST | $NORM_PUNC -l es | $REM_NON_PRINT_CHAR | $TOKENIZER -l es -no-escape -threads $N_THREADS > $SRC_TEST.n
cat $TGT_TEST | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $TGT_TEST.n
cat $SRC_TRAIN | $NORM_PUNC -l es | $REM_NON_PRINT_CHAR | $TOKENIZER -l es -no-escape -threads $N_THREADS > $SRC_TRAIN.n
cat $TGT_TRAIN | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $TGT_TRAIN.n

cd $MONO_PATH

cat $SRC_TRAIN.n > $CONCAT_SRC
cat $SRC_TOK >> $CONCAT_SRC
cat $TGT_TRAIN.n > $CONCAT_TGT
cat $TGT_TOK >> $CONCAT_TGT

# learn BPE codes
if [ ! -f "$BPE_CODES" ]; then
  echo "Learning BPE codes..."
  $FASTBPE learnbpe $CODES $CONCAT_SRC $CONCAT_TGT > $BPE_CODES
fi
echo "BPE learned in $BPE_CODES"

# apply BPE codes
if ! [[ -f "$SRC_TOK.$CODES" && -f "$TGT_TOK.$CODES" ]]; then
  echo "Applying BPE codes..."
  $FASTBPE applybpe $SRC_TOK.$CODES $SRC_TOK $BPE_CODES
  $FASTBPE applybpe $TGT_TOK.$CODES $TGT_TOK $BPE_CODES
fi
echo "BPE codes applied to ES in: $SRC_TOK.$CODES"
echo "BPE codes applied to EN in: $TGT_TOK.$CODES"

# extract vocabulary
if ! [[ -f "$SRC_VOCAB" && -f "$TGT_VOCAB" && -f "$FULL_VOCAB" ]]; then
  echo "Extracting vocabulary..."
  $FASTBPE getvocab $SRC_TOK.$CODES > $SRC_VOCAB
  $FASTBPE getvocab $TGT_TOK.$CODES > $TGT_VOCAB
  $FASTBPE getvocab $SRC_TOK.$CODES $TGT_TOK.$CODES > $FULL_VOCAB
fi
echo "Es vocab in: $SRC_VOCAB"
echo "En vocab in: $TGT_VOCAB"
echo "Full vocab in: $FULL_VOCAB"

# binarize data
if ! [[ -f "$SRC_TOK.$CODES.pth" && -f "$TGT_TOK.$CODES.pth" ]]; then
  echo "Binarizing data..."
  $UMT_PATH/preprocess.py $FULL_VOCAB $SRC_TOK.$CODES
  $UMT_PATH/preprocess.py $FULL_VOCAB $TGT_TOK.$CODES
fi
echo "Es binarized data in: $SRC_TOK.$CODES.pth"
echo "En binarized data in: $TGT_TOK.$CODES.pth"


#
# Download parallel data (for evaluation only)
#

cd $PARA_PATH

echo "Applying BPE to valid and test files..."
$FASTBPE applybpe $SRC_VALID.$CODES $SRC_VALID.n $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $TGT_VALID.$CODES $TGT_VALID.n $BPE_CODES $TGT_VOCAB
$FASTBPE applybpe $SRC_TEST.$CODES $SRC_TEST.n $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $TGT_TEST.$CODES $TGT_TEST.n $BPE_CODES $TGT_VOCAB
$FASTBPE applybpe $SRC_TRAIN.$CODES $SRC_TRAIN.n $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $TGT_TRAIN.$CODES $TGT_TRAIN.n $BPE_CODES $TGT_VOCAB

echo "Binarizing data..."
rm -f $SRC_VALID.$CODES.pth $TGT_VALID.$CODES.pth $SRC_TEST.$CODES.pth $TGT_TEST.$CODES.pth $SRC_TRAIN.$CODES.pth $TGT_TRAIN.$CODES.pth
$UMT_PATH/preprocess.py $FULL_VOCAB $SRC_VALID.$CODES
$UMT_PATH/preprocess.py $FULL_VOCAB $TGT_VALID.$CODES
$UMT_PATH/preprocess.py $FULL_VOCAB $SRC_TEST.$CODES
$UMT_PATH/preprocess.py $FULL_VOCAB $TGT_TEST.$CODES
$UMT_PATH/preprocess.py $FULL_VOCAB $SRC_TRAIN.$CODES
$UMT_PATH/preprocess.py $FULL_VOCAB $TGT_TRAIN.$CODES

# PARA_AUX Data
#cd $PARA_AUX_PATH

#echo "Parallel News Commentary Corpus setup"

echo "Tokenizing valid and test data..."
#cat $SRC_TRAIN_AUX | $NORM_PUNC -l es | $REM_NON_PRINT_CHAR | $TOKENIZER -l es -no-escape -threads $N_THREADS > $SRC_TRAIN_AUX.n
#cat $TGT_TRAIN_AUX | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $TGT_TRAIN_AUX.n

echo "Applying BPE to train files..."
#$FASTBPE applybpe $SRC_TRAIN_AUX.$CODES $SRC_TRAIN_AUX.n $BPE_CODES $SRC_VOCAB
#$FASTBPE applybpe $TGT_TRAIN_AUX.$CODES $TGT_TRAIN_AUX.n $BPE_CODES $TGT_VOCAB

echo "Binarizing data..."
#rm -f $SRC_TRAIN_AUX.$CODES.pth $TGT_TRAIN_AUX.$CODES.pth
#$UMT_PATH/preprocess.py $FULL_VOCAB $SRC_TRAIN_AUX.$CODES
#$UMT_PATH/preprocess.py $FULL_VOCAB $TGT_TRAIN_AUX.$CODES

# Mono Para Es Data
cd $MONO_PATH_ES

echo "Mono Para Spanish Corpus Setup"

echo "Tokenizing train data..."
cat $SRC_RAW_ES | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $SRC_TOK_ES
cat $TGT_RAW_ES | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $TGT_TOK_ES

echo "Applying BPE to train files..."
$FASTBPE applybpe $SRC_TOK_ES.$CODES $SRC_TOK_ES $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $TGT_TOK_ES.$CODES $TGT_TOK_ES $BPE_CODES $SRC_VOCAB

echo "Binarizing data..."
rm -f $SRC_TOK_ES.$CODES.pth $TGT_TOK_ES.$CODES.pth
$UMT_PATH/preprocess.py $FULL_VOCAB $SRC_TOK_ES.$CODES
$UMT_PATH/preprocess.py $FULL_VOCAB $TGT_TOK_ES.$CODES

# Mono Para En Data
cd $MONO_PATH_EN

echo "Mono Para English Corpus Setup"

echo "Tokenizing train data..."
cat $SRC_RAW_EN | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $SRC_TOK_EN
cat $TGT_RAW_EN | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $TGT_TOK_EN

echo "Applying BPE to train files..."
$FASTBPE applybpe $SRC_TOK_EN.$CODES $SRC_TOK_EN $BPE_CODES $TGT_VOCAB
$FASTBPE applybpe $TGT_TOK_EN.$CODES $TGT_TOK_EN $BPE_CODES $TGT_VOCAB

echo "Binarizing data..."
rm -f $SRC_TOK_EN.$CODES.pth $TGT_TOK_EN.$CODES.pth
$UMT_PATH/preprocess.py $FULL_VOCAB $SRC_TOK_EN.$CODES
$UMT_PATH/preprocess.py $FULL_VOCAB $TGT_TOK_EN.$CODES

cd $EVAL_PATH/sub4
echo " submission data tokenizing"
cat $SUB_SRC | $NORM_PUNC -l es | $REM_NON_PRINT_CHAR | $TOKENIZER -l es -no-escape -threads $N_THREADS > $SUB_SRC.n
cat $SUB_TGT | $NORM_PUNC -l en | $REM_NON_PRINT_CHAR | $TOKENIZER -l en -no-escape -threads $N_THREADS > $SUB_TGT.n

echo "applying bpe"
$FASTBPE applybpe $SUB_SRC.$CODES $SUB_SRC.n $BPE_CODES $SRC_VOCAB
$FASTBPE applybpe $SUB_TGT.$CODES $SUB_TGT.n $BPE_CODES $TGT_VOCAB

echo "binarizing"

$UMT_PATH/preprocess.py $FULL_VOCAB $SUB_SRC.$CODES
$UMT_PATH/preprocess.py $FULL_VOCAB $SUB_TGT$CODES



#
# Summary
#
echo ""
echo "===== Data summary"
echo "Monolingual training data:"
echo "    Es: $SRC_TOK.$CODES.pth"
echo "    En: $TGT_TOK.$CODES.pth"
echo "Mono Para Es training data:"
echo "    Es.disfluent: $SRC_TOK_ES.$CODES.pth"
echo "    Es: $TGT_TOK.$CODES_ES.pth"
echo "Mono Para En training data:"
echo "    En.disfluent: $SRC_TOK_EN.$CODES.pth"
echo "    En: $TGT_TOK_EN.$CODES.pth"
echo "Parallel train data:"
echo "    Es: $SRC_TRAIN.$CODES.pth"
echo "    En: $TGT_TRAIN.$CODES.pth"
echo "Parallel validation data:"
echo "    Es: $SRC_VALID.$CODES.pth"
echo "    En: $TGT_VALID.$CODES.pth"
echo "Parallel test data:"
echo "    Es: $SRC_TEST.$CODES.pth"
echo "    En: $TGT_TEST.$CODES.pth"
echo "Parallel auxiliary train data:"
echo "    Es: $SRC_TRAIN_AUX.$CODES.pth"
echo "    En: $TGT_TRAIN_AUX.$CODES.pth"
echo ""

#
# Train fastText on concatenated embeddings
#

if ! [[ -f "$CONCAT_BPE" ]]; then
  echo "Concatenating source and target monolingual data..."
  cat $SRC_TOK.$CODES $TGT_TOK.$CODES $SRC_TRAIN.$CODES $TGT_TRAIN.$CODES | shuf > $CONCAT_BPE
fi
echo "Concatenated data in: $CONCAT_BPE"

if ! [[ -f "$CONCAT_BPE.vec" ]]; then
  echo "Training fastText on $CONCAT_BPE..."
  $FASTTEXT skipgram -epoch $N_EPOCHS -minCount 0 -dim 512 -thread $N_THREADS -ws 5 -neg 10 -input $CONCAT_BPE -output $CONCAT_BPE
fi
echo "Cross-lingual embeddings in: $CONCAT_BPE.vec"
