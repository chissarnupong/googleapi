<!DOCTYPE html>
<html lang="">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Title Page</title>

    <!-- Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.3/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

    <style>
        table {
      border-collapse: collapse;
      width: 50%;
      color: #588c7e;
      font-family: monospace;
      font-size: 25px;
      text-align: left;
        }
     th {
      background-color: #588c7e;
      color: white;
       }
     tr:nth-child(even) {background-color: #f2f2f2}
    </style>

    <title>Map</title>
    <meta name="viewport" content="initial-scale=1.0">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script type="text/javascript">
        < script src = "https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false" >
    </script>
    <meta charset="utf-8">
    <style>
        #map {
            height: 100%;
            width: 100%;
        }

        html,
        body {
            height: 100%;
            margin: 0;
            padding: 0;
        }
    </style>


</head>

<body>
    <h1 class="text-center">Route Detection and
Coordinate Mapping
Device using Wi-Fi
Signal</h1>

    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <!-- Bootstrap JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


    <body>

        <div id="map"></div>
        <script>
            function initMap() {
                var mapOptions = {
                    center: {
                        lat: 13.796343,
                        lng: 100.322915
                    },
                    zoom: 18,
                }

                // function initMap() {
                // var mapOptions = {
                //     zoom: 3,
                //     center: {lat: 0, lng: -180},
                //     mapTypeId: 'terrain'
                //   });

                var maps = new google.maps.Map(document.getElementById("map"), mapOptions);


                //////////////////////////// marker /////////////////////////////////////////

                var marker, info;
                $.getJSON("jsondata.php", function (jsonobj) {
                    $.each(jsonobj, function (i, item) {
                        var marker = new google.maps.Marker({
                            position: new google.maps.LatLng(item.lat, item.lng),
                            map: maps,
                        });
                        info = new google.maps.InfoWindow();
                        google.maps.event.addListener(marker, 'click', (function (marker, i) {
                            return function () {
                                info.setContent(item.name);
                                info.open(maps, marker);
                            }
                        })(marker, i));
                    });
                });


                //////////////////// PolyLine /////////////////////////////////////////////

                var flightPlanCoordinates = [];
                $.getJSON("jsonpath.php", function (json) {
                    for (var i = 0; i < json.length; i++) {
                        var latLng = new google.maps.LatLng((json[i].lat), (json[i].lng));
                        flightPlanCoordinates.push(latLng);
                    }
                    var flightPath = new google.maps.Polyline({
                        path: flightPlanCoordinates,
                        geodesic: true,
                        strokeColor: '#0000FF',
                        strokeOpacity: 1.0,
                        strokeWeight: 2,
                        icons: [{
                            icon: {
                                path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW
                            },
                            offset: '100%',
                            repeat: '65px'
                        }]

                    });
                    flightPath.setMap(maps);
                });



            }
        </script>
        <script async defer <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCvKYJq_cHLpj6GOfvZghyNgLoy1Da3quk&callback=initMap">
        </script>

        <?php
  $mysqli = NEW MySQLi("localhost", "root", "", "map");
   $Mac = $mysqli->query("SELECT DISTINCT src , COUNT(DISTINCT name ) FROM info GROUP BY src HAVING COUNT(DISTINCT name ) > 1 ");
 ?>

        <select name="MAC" id="MAC">
            <?php
   while($row = $Mac->fetch_assoc())
   {
    $mac = $row['src']; 
    echo "<option value='$mac'>$mac</option>";
   }
   ?>
        </select>



        <table>
            <tr>
                <th>MAC</th>
            </tr>
            <?php
   $conn = mysqli_connect("localhost", "root", "", "map");
     // Check connection
     if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
     }
     $sql = "SELECT src , COUNT(DISTINCT name ) FROM info GROUP BY src HAVING COUNT(DISTINCT name ) > 2 ";
     $result = $conn->query($sql);
     if ($result->num_rows > 0) {
      // output data of each row
      while($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["src"] . "</td><tr>";
    //   echo "<tr><td>" . $row["name"]. "</td><td>" . $row["src"] . "</td><td>". $row["sig"]. "</td><td>". $row["tst"]. "</td><tr>";
   }
   echo "</table>";
   } else { echo "0 results"; }
   $conn->close();
   ?>
        </table>





    </body>

</html>