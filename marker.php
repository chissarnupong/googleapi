<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
        <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <meta charset="utf-8">
    <title>Simple Marker Icons</title>
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
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

      // This example adds a marker to indicate the position of Bondi Beach in Sydney,
      // Australia.
      function initMap() {
        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 4,
          center: {lat: -33, lng: 151}
        });
        var image = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png';

      //   $.getJSON("jsondata.php", function(jsonobj) {
      //     $.each(jsonobj, function(i, item){
      //       var marker = new google.maps.Marker({
      //         position: new google.maps.LatLng(item.lat,item.ing),
      //         map: maps,
      //         icon: image
      //       });
      //       info = new google.maps.InfoWindow();
      //       google.maps.event.addListener(marker, 'click', (function(marker, i) {
      //       return function () {
      //         info.setContent(item.name);
      //         info.open(maps, marker);
      //       }
      //     })(marker, i));
      //   });
      // });

      var TMarker = new google.maps.Marker({
        position: {lat: 13.8479, lng: 100.604},
        map: map,
        icon: image
      });

        var beachMarker = new google.maps.Marker({
          position: {lat: -33.890, lng: 151.274},
          map: map,
          icon: image
        });
      }
    </script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCvKYJq_cHLpj6GOfvZghyNgLoy1Da3quk&callback=initMap">
    </script>
  </body>
</html>
