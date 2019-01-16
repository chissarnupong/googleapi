<html>
<body>
  <?php
     $signal = "";
     $src = "";
     $time = "";
     $entry = "";
    //analyse data function
    if($dirFromClients = opendir('.\fromClients')){ // opendir to get file directory and use to read file name in directory to open with fopen()
        while (false !== ($entry = readdir($dirFromClients))) { // string readdir (resource $dir_handle)
        if($entry != "." && $entry != ".."){
          $file = fopen(__DIR__ . '/./fromClients/'.$entry, "r"); // __DIR__ is global constant that gives you the directory of the current file ('.' just gives you the directory of the root script executing).
          echo "File : ".$entry."<br>";
          //prepare var to collect data
          while(!feof($file)){
            //echo fgets($file)."<br>"; //test open file
            $Line = fgets($file);//read each line
            $StrArr = str_split($Line);// split them to 1:1 array
            //handmade fanction
            $submitHH = ""; //convert to int when calculate time
            $submitMM = "";
            $submitSS = "";

            if(strpos($Line,"RouterOS")!=false){ //that line must contain "RouterOS"
              $month = "";
              $date = "";
              $year = "";

              $month = $StrArr[2].$StrArr[3].$StrArr[4];
              $date = $StrArr[6].$StrArr[7];
              $year = $StrArr[9].$StrArr[10].$StrArr[11].$StrArr[12];

              if ($StrArr[14]==" "&&$StrArr[15]!=" ") {
                $submitHH = $submitHH.$StrArr[15];
              }else {
                $submitHH = $submitHH.$StrArr[14].$StrArr[15];
              }
              if ($StrArr[17]==" "&&$StrArr[18]!=" ") {
                $submitMM = $submitMM.$StrArr[18];
              }else {
                $submitMM = $submitMM.$StrArr[17].$StrArr[18];
              }
              if ($StrArr[20]==" "&&$StrArr[21]!=" ") {
                $submitSS = $submitSS.$StrArr[21];
              }else {
                $submitSS = $submitSS.$StrArr[20].$StrArr[21];
              }

              echo "month  : ".$month."<br>"; //put any echo line to DB
              echo "date   : ".$date."<br>";
              echo "year   : ".$year."<br>";
              echo "subHH  : ".$submitHH."<br>";
              echo "subMM  : ".$submitMM."<br>";
              echo "subSS  : ".$submitSS."<br>----------------<br><br>";

            } elseif (strpos($Line,"time=")!=false) {
              $time = "";
              $channel = "";

              $posTime = strripos($Line,"time=")+strlen("time=")-1;
              $posChan = strripos($Line,"channel=")+strlen("channel=");

              for ($i=$posTime+1; $StrArr[$i]!=" ";$i++ ) {
                $time = $time.$StrArr[$i];
              }
              for ($i=$posChan+1; $StrArr[$i]!="\"";$i++ ) {
                $channel = $channel.$StrArr[$i];
              }
              //$time = $StrArr[$posTime+1].$StrArr[$posTime+2].$StrArr[$posTime+3].$StrArr[$posTime+4].$StrArr[$posTime+5];
              //$channel = $StrArr[$posChan+1].$StrArr[$posChan+2].$StrArr[$posChan+3].$StrArr[$posChan+4].$StrArr[$posChan+5].$StrArr[$posChan+6].$StrArr[$posChan+7].$StrArr[$posChan+8].$StrArr[$posChan+9].$StrArr[$posChan+10];

              echo "time   : ".$time."<br>"; //put any echo line to DB
              echo "channel: ".$channel."<br>";

              //calculate time when data was captured
              $timeFloat = floatval($time);
              if($submitSS!=""&&$submitMM!=""&&$submitHH!=""&&$month!=""&&$date!=""&&$year!=""){// for error prevention when data line was swap
                $ss = floatval($submitSS);
                $mm = intval($submitMM);
                $hh = intval($submitHH);

                if($ss<$timeFloat){ // if sec not enough
                    if((60*$mm)+$ss<$timeFloat){ //if min not enough
                      if((3600*$hh)+(60*$mm)+$ss<$timeFloat) { //if hr not enough
                          //day -1 -> 24*3600 added , 1st janruary -> 31st december decrease year
                          //day by $month
                          if($date=="1"){
                            switch ($month) {
                              case 'jan': $month = "dec"; break;
                              case 'feb': $month = "jan"; break;
                              case 'mar': $month = "feb"; break;
                              case 'apr': $month = "mar"; break;
                              case 'may': $month = "apr"; break;
                              case 'jun': $month = "may"; break;
                              case 'jul': $month = "jun"; break;
                              case 'aug': $month = "jul"; break;
                              case 'sep': $month = "aug"; break;
                              case 'oct': $month = "sep"; break;
                              case 'nov': $month = "oct"; break;
                              case 'dec': $month = "nov"; break;
                          }
                          $date = "31";
                        }else {
                          $date = strval(intval($date)-1);
                        }
                        $hh = $hh + 24;
                      }
                    }
                }
              }
              //echo "timeF  : ".$timeFloat."<br>";
            }elseif (strpos($Line,"signal-at-rate=")) {
              $signal = "";
              $src = "";

              $posSign = strripos($Line,"signal-at-rate=")+strlen("signal-at-rate=")-1;
              $posSrc = strripos($Line,"src=")+strlen("scr=")-1;

              for ($i=$posSign+1; $StrArr[$i]!="@";$i++ ) {
                $signal = $signal.$StrArr[$i];
              }
              for ($i=$posSrc+1; $StrArr[$i]!=chr(10);$i++ ) { // 10 is next char from last char in this line : check by print them all in int with ord()
                //echo "bug : ".ord($StrArr[$i])."<br>";
                $src = $src.$StrArr[$i];
              }
              /*
              $signal = $StrArr[$posSign+1].$StrArr[$posSign+2].$StrArr[$posSign+3];
              */
              $src = $StrArr[$posSrc+1].$StrArr[$posSrc+2].$StrArr[$posSrc+3].$StrArr[$posSrc+4].$StrArr[$posSrc+5].$StrArr[$posSrc+6].$StrArr[$posSrc+7].$StrArr[$posSrc+8].$StrArr[$posSrc+9].$StrArr[$posSrc+10];
              $src = $src.$StrArr[$posSrc+11].$StrArr[$posSrc+12].$StrArr[$posSrc+13].$StrArr[$posSrc+14].$StrArr[$posSrc+15].$StrArr[$posSrc+16].$StrArr[$posSrc+17];

              echo "signal : ".$signal."<br>"; //put any echo line to DB
              echo "src    : ".$src."<br><br>";
            }


          /////////////////////////////////////////////  connection db //////////////////////////////////////////////
            $link = mysqli_connect("localhost", "root", "", "map");

            // Check connection
        
            if($link === false){
                die("ERROR: Could not connect. " . mysqli_connect_error());
            }

            $sql = "INSERT INTO info (name, src, sig, tst) VALUES ('$entry','$src', '$signal', '$time')";

          //$sql = "INSERT INTO info (name, src, sig, tst) VALUES ('$entry','$src', '$signal', '$time') ON DUPLICATE KEY UPDATE sig=$signal ";
        
        
            if(mysqli_query($link, $sql)){
               // echo "Records added successfully.";
            } else{
                //echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
            }
        
           
           
            // close connection
            mysqli_close($link);
          
          //////////////////////////////////////////////////////////////////////////////////////////////////////////


          }
          fflush($file);
          fclose($file);
          echo "<br>"."----------------------------------"."<br>";

        }
      }

  }
   ?>
</body>
</html>
