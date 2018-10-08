#! /bin/bash
QT_LOGGING_RULES='*=false'
export QT_LOGGING_RULES
nature=flow
outputs_txt=data/$nature-outputs.txt
first_txt=data/$nature-first-images.txt
second_txt=data/$nature-second-images.txt
converter=$(command -v color_flow)
eog=$(command -v eog)
outdir="outputs"
[ ! -d $outdir ] && mkdir $outdir

main() {
     ./run-network.sh -n FlowNet2-s -g 1 -vv $first_txt $second_txt $outputs_txt
}

show() { 
    flos=$(cat $outputs_txt)
    #echo $flos
    #mlen=${#flos[*]}
    for flo in ${flos[@]}; do
        out=$outdir/${flo%.*}.png
        flo1=$outdir/$flo
        mv -f $flo $flo1
        echo " converting $flo to $out"
        $1 $flo1 $out
        eog $out 2>/dev/null &
    done
}

run() {
    time main
    time show $converter
    echo "pkill -9 eog"
}

if [ -z $eog ]; then
    echo "eog not found!"
    echo "sudo apt install eog"
    exit 1
fi

if [ -z $converter ]; then
    echo "convert not found"
    echo "wget http://vision.middlebury.edu/flow/code/flow-code.zip"
    exit 1
fi
run
read -p "Close all windows?" -n 1 -r
[[ $REPLY =~ ^[Yy]$ ]] && pkill -9 eog
