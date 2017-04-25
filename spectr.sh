for i in `seq 1 4`; do
    suop op=avg < Su/Combine.ch$i.su | suop op=avg | sufft | suamp | suximage legend=1 title="Test chan $i" &
done


