mkdir Segy
mkdir Su

cat 16* | sivy -i /dev/stdin -o Segy/Combine -k 1,2,3,4 -l Combine.log -p -v

for i in 1 2 3 4; do
segyread tape=Segy/Combine.ch$i.segy | segyclean > Su/Combine.ch$i.su ;
rm Segy/Combine.ch$i.segy
done

suop op=avg < Su/Combine.ch3.su | suximage title="Test chan 3" &




