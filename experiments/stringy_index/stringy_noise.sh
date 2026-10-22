#!/bin/bash

# Example:
# bash experiments/stringy_index/stringy_noise.sh cubic 500 1 100 1111 experiments/stringy_index/cubic_noise.csv "0,0.001,0.01,0.1"

# Get arguments from command line
PATTERN=$1
N=$2
REP_START=$3
REP_END=$4
BASE_SEED=$5
FLNAME=$6
NOISE_LEVELS=$7

if [ -z "$PATTERN" ] || [ -z "$N" ] || [ -z "$REP_START" ] || \
   [ -z "$REP_END" ] || [ -z "$BASE_SEED" ] || \
   [ -z "$FLNAME" ] || [ -z "$NOISE_LEVELS" ]; then

  echo "Error: Missing arguments"
  echo "Usage: ./stringy_noise.sh <pattern> <n> <rep_start> <rep_end> <base_seed> <csv_file> <noise_levels>"
  exit 1
fi

echo "========================================="
echo "Starting Stringy noise simulation:"
echo "  pattern:       $PATTERN"
echo "  sample size:   $N"
echo "  rep_start:     $REP_START"
echo "  rep_end:       $REP_END"
echo "  base_seed:     $BASE_SEED"
echo "  outfile:       $FLNAME"
echo "  noise levels:  $NOISE_LEVELS"
echo "========================================="

# Pass arguments to R script
Rscript experiments/stringy_index/stringy_noise_batch.R \
  "$PATTERN" "$N" "$REP_START" "$REP_END" \
  "$BASE_SEED" "$FLNAME" "$NOISE_LEVELS"

# example run
# bash experiments/stringy_index/stringy_noise.sh \
  # quartic \
  # 100 \
  # 1 \
  # 100 \
  # 1111 \
  # experiments/stringy_index/quartic_n100.csv \
  # "$(Rscript -e 'cat(paste(seq(0, 1, length.out = 20), collapse = ","))')"
