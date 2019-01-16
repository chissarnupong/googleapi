<!DOCTYPE html>
<html>
  <head>
    <title>Map</title>
    <meta name="viewport" content="initial-scale=1.0">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script type="text/javascript">
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
    <meta charset="utf-8">
    <style>
      #map {
        height: 40%;
        width: 30%;
      }
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
    </style>
  </head>
  <body>

    <div id="map"></div>
    <script>

    function initMap() {
      var mapOptions = {
      center: {lat: 13.794193, lng: 100.323257 },
      zoom: 18
    }

      var maps = new google.maps.Map(document.getElementById("map"), mapOptions);
      var marker, info;

      $.getJSON("jsondata.php", function(jsonobj) {
        $.each(jsonobj, function(i, item){
          var marker = new google.maps.Marker({
            position: new google.maps.LatLng(item.lat,item.lon),
            map: maps,
          });
         info = new google.maps.InfoWindow();
          google.maps.event.addListener(marker, 'click', (function(marker, i) {
          return function () {
            info.setContent(item.name);
            info.open(maps, marker);
          }
        })(marker, i));
      });
    });

  }
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCvKYJq_cHLpj6GOfvZghyNgLoy1Da3quk&callback=initMap"
    async defer></script>
  </body>
</html>
