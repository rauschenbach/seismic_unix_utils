mkdir Segy
mkdir Su

cat 16* | sivy -i /dev/stdin -o Segy/Combine -k 1,2,3,4 -l Combine.log -p -v

for i in 1 2 3 4; do
segyread tape=Segy/Combine.ch$i.segy | segyclean > Su/Combine.ch$i.su ;
rm Segy/Combine.ch$i.segy
done

for i in `seq 1 4`; do
    # suop op=avg < Su/Combine.ch$i.su | suxgraph title="Test chan $i" &
    suascii < Su/Combine.ch$i.su bare=1 | gawk 'BEGIN{i=0}{if (NF>=1) {print 0.002*i, $1*0.15; i=i+1} }' > Data$i.dat
    xmgrace Data$i.dat & 
    suop op=avg < Su/Combine.ch$i.su | suascii bare=1 | awk 'BEGIN{s=0} {s=s+$1^2}END{print sqrt(s/FNR)*0.15}'
done




