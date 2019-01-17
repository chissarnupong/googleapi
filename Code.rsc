



{
    :local time [/sys clock get time];
    :local Fname ("test"."_".[:pick [$time] 0 2].[:pick [$time] 3 5].[:pick [$time] 6 8].".pcap");
    :put $Fname;
    /interface wireless sniffer set multiple-channels=yes file-name="$Fname" receive-errors=no only-headers=yes memory-limit=1024;
    :delay 1;
    /interface wireless sniffer sniff wlan1 dura=1 interval=00:00:05;
    :delay 2;
    /tool fetch upload=yes src-path=$Fname dst-path=$Fname mode=ftp user=admin password="123456" address=192.168.1.94 keep-result=no;
    delay 2;
    /file remove $Fname;
    :log info ("file rem $Fname")
}



###### Sniff No File ########## Not work. Becouse when send data sniffer must stop
{
    :local time [/sys clock get time];
    :set time ([:pick [$time] 0 2].",".[:pick [$time] 3 5].",".[:pick [$time] 6 8]);
    #:set time [:toarray $time];
    :put [$time];
    :local snifCount [/int wire sniff packet find type=probe-req];
    :local package;
    :fore i in=$snifCount do={
        :local t [:toarray $time];
        :local signal [/int wire sniff pack get $i signal];
        :local sniffTime [/int wire snif pack get $i time];
        :local mac [/int wire sniff pack get $i src];
        :set sniffTime ([:pick [$sniffTime] 0 1]);
        :set ($t->2) (($t->2)+$sniffTime);
        
        {
            #Converst Time
            :local M (($t->2) / 60); #S->M
            :set ($t->2) (($t->2)%60); #S
            :set ($t->1) (($t->1)+$M); #M
            :local H (($t->1) / 60); #M->H
            :set ($t->1) (($t->1)%60); #M
            :set ($t->0) ((($t->0)+$H)%24); #H
            :set ($t->2) [:tostr ($t->2)];
            :set ($t->1) [:tostr ($t->1)];
            :set ($t->0) [:tostr ($t->0)];
            # add 0 if int < 10
            if (($t->2)<10) do={:set ($t->2) ("0".($t->2));}
            if (($t->1)<10) do={:set ($t->1) ("0".($t->1));}
            if (($t->0)<10) do={:set ($t->0) ("0".($t->0));}
                
        }
        :set package (($t->0).":".($t->1).":".($t->2)." ".$mac." ".$signal);
        :put $mac;
    }

}
###################################################################################

 #test array
{
   
:local myarray [:toarray value="abc,def,ghi"];
:put $myarray;

:put ($myarray->0);
:put ($myarray->1);
:put ($myarray->2);

:foreach element in=$myarray do={
    :put $element
}

:for counter from=0 step=1 to=2 do={
    :put ($myarray->$counter)
}}
##############################

    :local sniff [/system script job find script="Sniffer"];if ([:len $sniff] = 0) do={put [len $sniff];}

###### RouterOS V6.43.0 Sniff ########## great work
:log warning ("Sniff ".$IP." ".$GPSsent);
:if ($GPSsent) do={
        if (([:len [/system script job find script="Sniffer"]] = 1)) do={
        :local time [/sys clock get time];
        :global Fname ("test"."_".[:pick [$time] 0 2].[:pick [$time] 3 5].[:pick [$time] 6 8]);
        #:set time ([:pick [$time] 0 2].",".[:pick [$time] 3 5].",".[:pick [$time] 6 8]);
        #:set time [:toarray $time];
        #:put [$time];
        #:local snifCount [/int wire sniff packet find type=probe-req];
        /interface wireless sniffer set multiple-channels=yes file-n="" receive-errors=no only-headers=yes memory-limit=10240;
        /int wi sniffer sniff wlan1 dura=60;
        /int wire sniff packet print file="$Fname" detail where type=probe-req
    }
}

############ push ###########
:local IP [/sys script environment get IP value];
:local GPSsent [/sys script environment get GPSsent value];
:if ($GPSsent) do={
    if ([:len [/system script job find script="Push"]] = 1) do={
        :local txtCount [/file find name~"test" type=
".txt file" and name!=("$Fname".".txt")]
        :local count [/file print count-only where name~"test" type=
".txt file" and name!=("$Fname".".txt")]
        fore i in=($txtCount) do={
            :local fileName [/file get $i name]
            /tool fetch upload=yes src-path=$fileName dst-path=$fileName mode=ftp user=admin password="123456" address=192.168.30.157 keep-result=no;
            :delay 2;
            if ($count > 1) do={
                :put $i;
                /file remove $i;
                :set count ($count-1);
            }
        }
    }
}
###################################################################################



{put [time [ 
:loc time [/sys clock get time];
:loc Fname ("test"."_".[:pick [$time] 0 2].[:pick [$time] 3 5].[:pick [$time] 6 8]);
:put $Fname;
/interface wireless sniffer set multiple-channels=yes file-n="$Fname" receive-errors=no only-headers=yes memory-limit=1024;
#:delay 1;
/int wi sniffer sniff wlan1 dura=10 interval=00:00:05 do={:loc snif [pack pr];:put $snif;/ip fire lay set 0 re="snif"};

#delay 2;
put "Upload";
#/tool fetch upload=yes src-path=$Fname dst-path=$Fname mode=ftp user=admin password="123456" address=192.168.1.94 keep=no;
#delay 2;
/file rem $Fname;
:log info ("file rem")
 ];];}
####################################################################################################


 ####### GPS #######

{
 if ([:len [/system script job find script="GPS"]] = 1 && !$GPSsent) do={
    :global GPSsent;
    :local lat;
    :local lng;
    :local IP ("192.168.88.190");
    :local ID [/system id get name];
    :local speedMT;
    :local GetGPS false;
    while (!$GetGPS) do={
        /sys gps monitor once do={
        :set speedMT [:pick $speed 0 7];
        :if ($speedMT <= 0.0100000 && $valid) do={
            :set lat [$latitude];
            :set lng [$longitude];
            :set GetGPS true;
            }
        }
        :delay 1s;
    }
    #Convert GPS
    :local degreestart [:find $lng " " -1];
    :local minutestart [:find $lng " " $degreestart];
    :local secondstart [:find $lng "'" $minutestart];
    :local zeros "";
    :local secondend;
    :local secfract;
    :if ([:len [:find $lng "." 0]] < 1) do={
        :set secondend [:find $lng "'" $secondstart];
        :set secfract "0";
    } else={
            :set secondend [:find $lng "." $secondstart];
            :set secfract [:pick $lng ($secondend + 1) ($secondend + 2)];
        };
    :local longdegree;
    :if ([:pick $lng 0 1] = "W") do={
        :set longdegree "-";
    } else={
        :set longdegree "+";
    };
    :set longdegree ($longdegree . [:pick $lng 2 $minutestart]);
    :local longmin [:pick $lng ($minutestart + 1) $secondstart];
    :local longsec [:pick $lng ($secondstart + 2) $secondend];
    :local longfract ((([:tonum $longmin] * 600000) + ([:tonum $longsec] * 10000) + ([:tonum $secfract] * 1000) ) / 36);
    :while (([:len $zeros] + [:len $longfract]) < 4) do={
    :set zeros ($zeros . "0");
    };
    :set lng ($longdegree . "." . $zeros . $longfract);
    :set degreestart [:find $lat " " -1];
    :set minutestart [:find $lat " " $degreestart];
    :set secondstart [:find $lat "'" $minutestart];
    :if ([:len [:find $lat "." 0]] < 1) do={
        :set secondend [:find $lat "'" $secondstart];
        :set secfract "0";
    } else={
        :set secondend [:find $lat "." $secondstart];
        :set secfract [:pick $lat ($secondend + 1) ($secondend +2)];
    };
    :local latdegree;
    :if ([:pick $lat 0 1] = "N") do={
        :set latdegree "+";
    } else={
        :set latdegree "-";
    };
    :set latdegree ($latdegree . [:pick $lat 2 $minutestart]);
    :local latmin [:pick $lat ($minutestart + 1) $secondstart];
    :local latsec [:pick $lat ($secondstart + 2) $secondend];
    :local latfract ((([:tonum $latmin] * 600000) + ([:tonum $latsec] * 10000) +([:tonum $secfract] * 1000)) / 36);
    :set zeros "";
    :while (([:len $zeros] + [:len $latfract]) < 4) do={
        :set zeros ($zeros . "0");
    };
    :set lat ($latdegree . "." . $zeros . $latfract);
    do {/tool fetch url="http://$IP/routedetect/googleapi/gps.php\?name=$ID&lat=$lat&lng=$lng" keep=no;:set $GPSsent ("true"); } on-error={:set $GPSsent ("false");}
    :log warning ("GPS: ".$ID." ".$lat." ".$lng." Send: ".$GPSsent);
  }
}





while (true) do={
 :local time [/system clock get time];
 :put $time
 :set $time [:pick $time 4 5];
 :put $time
 :set $time (($time*2)/5);
 :put $time
 :delay 60:
}














/tool fetch url="http://192.168.1.95/upload/upload.php" http-method=post http-data=mutipart/from-data src-pa="test_073829 - Copy.pcap" keep=no;







{
    :local result [/tool fetch url="http://192.168.1.95" output=user];
    :if ($result->"status" = "finished") do={
        :if ($result->"data" = "0") do={
            :put "yes";
        } else={
            :put "no"
        }
    }
}
 192.168.1.93




 
 
 {
 :local GPS;
 :global GPSsent;
 :local lat;
 :local lng;
 :local IP 192.168.88.190;
 :local ID [/system id get name];
 :local time [/system clock get time];
 :local speedMT;
 :local GetGPS false;
 while (!$GetGPS) do={
/sys gps monitor once do={
     #:set $lat "12.34";
     #:set $lon "43.21";
     :set speedMT [:pick $speed 0 4];
     :if ($valid) do={
        :set lat [:pick $latitude 0 1];
        :set lng [:pick $longitude 0 1];
        :set GetGPS true;
     }
    }
 }
    :put ($speedMT." ".$lat." ".$lng);
if (($lat!="none")&&($lng!="none")) do={
    :set GPS True;
    do {/tool fetch url="http://$IP/routedetect/googleapi/gps.php\?name=$ID&lat=$lat&lng=$lng" keep=no;:set $GPSsent true; } on-error={:set $GPSsent false;}
    #/tool fetch url="http://$IP/googleapi/gps.php\?name=$ID&lat=$lat&lon=$lon" keep=no;
    :put ($ID.":".$lat.":".$lng);
    :put ("Get GPS".";"." ".$GPS);
    :put ("GPS Sent".";"." ".$GPSsent);
    :put ("time%5"." ".$time);
    } else={
        :set GPS false;
    }
}






date-and-time: nov/26/2018 11:14:44
             latitude: N 13 47' 44.712''
            longitude: E 100 19' 26.316''
             altitude: 37.400002m
                speed: 0.851920 km/h
  destination-bearing: none
         true-bearing: 181.830002 deg. True
     magnetic-bearing: 0.000000 deg. Mag
                valid: yes
           satellites: 8
          fix-quality: 1
  horizontal-dilution: 1.09






 {
    :local degreestart [:find $longitude " " -1];
    :local minutestart [:find $longitude " " $degreestart];
    :local secondstart [:find $longitude "'" $minutestart];
    :local zeros "";

    :local secondend;
    :local secfract;
    :if ([:len [:find $longitude "." 0]] < 1) do={
    :set secondend [:find $longitude "'" $secondstart];
    :set secfract "0";
    } else={
        :set secondend [:find $longitude "." $secondstart];
        :set secfract [:pick $longitude ($secondend + 1) ($secondend + 2)];
    };
    :local longdegree;
    :if ([:pick $longitude 0 1] = "W") do={
        :set longdegree "-";
    } else={
        :set longdegree "+";
    };
    :set longdegree ($longdegree . [:pick $longitude 2 $minutestart]);
    :local longmin [:pick $longitude ($minutestart + 1) $secondstart];
    :local longsec [:pick $longitude ($secondstart + 2) $secondend];
    :local longfract ((([:tonum $longmin] * 600000) + ([:tonum $longsec] * 10000) + ([:tonum $secfract] * 1000) ) / 36);
    :while (([:len $zeros] + [:len $longfract]) < 4) do={
    :set zeros ($zeros . "0");
    };
    :global newlong ($longdegree . "." . $zeros . $longfract);

    :set degreestart [:find $latitude " " -1];
    :set minutestart [:find $latitude " " $degreestart];
    :set secondstart [:find $latitude "'" $minutestart];
    :if ([:len [:find $latitude "." 0]] < 1) do={
        :set secondend [:find $latitude "'" $secondstart];
        :set secfract "0";
    } else={
        :set secondend [:find $latitude "." $secondstart];
        :set secfract [:pick $latitude ($secondend + 1) ($secondend +2)];
    };
    :local latdegree;
    :if ([:pick $latitude 0 1] = "N") do={
        :set latdegree "+";
    } else={
        :set latdegree "-";
    };
    :set latdegree ($latdegree . [:pick $latitude 2 $minutestart]);
    :local latmin [:pick $latitude ($minutestart + 1) $secondstart];
    :local latsec [:pick $latitude ($secondstart + 2) $secondend];
    :local latfract ((([:tonum $latmin] * 600000) + ([:tonum $latsec] * 10000) +([:tonum $secfract] * 1000)) / 36);
    :set zeros "";
    :while (([:len $zeros] + [:len $latfract]) < 4) do={
        :set zeros ($zeros . "0");
    };
    :global newlat ($latdegree . "." . $zeros . $latfract);
}