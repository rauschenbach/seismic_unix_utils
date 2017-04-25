mkdir Segy
mkdir Su
#-----------------------------------------------------------------------------------------------------------------
ls 16* > temp.file
gawk '{ print "checker", $1  }' temp.file > tempfile.sh
sh tempfile.sh | grep SeismicData |\
 gawk '{ split($4,a,"-"); split($6,b,":");
  k[1]=31;k[2]=28;k[3]=31; k[4]=30; k[5]=31; k[6]=30
  k[7]=31;k[8]=31;k[9]=30;k[10]=31;k[11]=30;k[12]=31

  if($3>1)
  {
  hour=b[1]; min=b[2];sec=b[3]
  sec2=sec+30; min2=min; hour2=hour

  day= int(a[1]); mounth=int(a[2]); year=int(a[3])
  day2 = day; mounth2 = mounth; year2=year

  if(year==int(year/4)*4) {k[2]=29}

  if( sec2  >= 60 ) { sec2=sec2-60; min2=min2+1 }
  if( min2  >= 60 )  { min2=min2-60; hour2=hour2+1 }
  if( hour2 >= 24 ) { hour2=hour2-24; day2=day2+1 }

  if( day2 > k[mounth] ) { day2=1;  mounth2=mounth2+1  }

  if(mounth2 > 12) { mounth2=1; year2=year2+1 ; print year2 }

  printf("%02d:%02d:%02.3f    %02d.%02d.%4d     0       30      0\n",hour,min,sec,day,mounth,year);
  printf("%02d:%02d:%02.3f    %02d.%02d.%4d     0       30      0\n",hour2,min2,sec2,day2,mounth2,year2);
 }
 }' > Control.auto 
#---------------------------------------------------------------------------------------------------------------
cat 16* | sivy -i /dev/stdin -o Segy/Combine -k 4 -l Combine.log -p -v -c Control.auto

segyread tape=Segy/Combine.ch4.segy | segyclean > Su/Combine.ch4.su ;
rm Segy/Combine.ch4.segy

 suop op=avg < Su/Combine.ch4.su | suximage title="Test chan 4" &
#    suascii < Su/Combine.ch$i.su bare=1 | gawk 'BEGIN{i=0}{if (NF>=1) {print 0.002*i, $1*0.15; i=i+1} }' > Data$i.dat
#    xmgrace Data$i.dat & 
#   suop op=avg < Su/Combine.ch$i.su | suascii bare=1 | awk 'BEGIN{s=0} {s=s+$1^2}END{print sqrt(s/FNR)*0.15}'




