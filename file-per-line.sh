#!/bin/bash

date=$(date +%Y-%m-%d-%H-%M-%S)
output_dir=~/Downloads/$date
mkdir -p "$output_dir"
echo "created $output_dir"


echo "current time $date"

i=0
while read -r line; do 
    echo "$line" | docker run -i -v "$output_dir":/piper/output piper-env /piper/build/piper --model /piper/model_files/en_US-ryan-high.onnx --output_file /piper/output/$i.wav
    ((i++))
done < /dev/stdin
