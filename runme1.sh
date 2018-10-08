#! /bin/bash
QT_LOGGING_RULES='*=false'
export QT_LOGGING_RULES
outdir="outputs"
[ ! -d $outdir ] && mkdir $outdir

outputs_flo=$outdir/flow.flo
echo $outputs_flo
first_png="data/0000000-imgL.png"
second_png="data/0000001-imgL.png"
converter=$(command -v color_flow)
eog=$(command -v eog)

main() {
    ./run-network.sh -n FlowNet2 -v $first_png $second_png $outputs_flo
}


show() { 
    flo=$outputs_flo
    out=${flo%.*}.png
    echo " $1 converting $flo to $out"
    if [ ! -f $out ]; then
        $1 $flo $out
    fi
    eog $out 2>/dev/null &

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
time main
time show $converter
read -p "Close all windows?" -n 1 -r
[[ $REPLY =~ ^[Yy]$ ]] && pkill -9 eog
