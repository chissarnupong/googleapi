<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title></title>
  </head>
  <body>
    Name : <?php echo $_GET["name"]; ?> <br>
    Latitude : <?php echo $_GET["lat"]; ?> <br>
    Longtitude :<?php echo $_GET["lng"]; ?>
</form>
  </body>
</html>

<?php

    /* Attempt MySQL server connection. Assuming you are running MySQL
    server with default setting (user 'root' with no password) */

    $link = mysqli_connect("localhost", "root", "", "map");

    // Check connection

    if($link === false){
        die("ERROR: Could not connect. " . mysqli_connect_error());
    }

    $name = $_GET['name'];
    $lat =  $_GET['lat'];
    $lng =  $_GET['lng'];

    // attempt insert query execution
 //$sql = "INSERT INTO maping (name, lat, lng) VALUES ('$name', '$lat', '$lng')";
 
 $sql = "INSERT INTO maping (name, lat, lng) VALUES ('$name', '$lat', '$lng') ON DUPLICATE KEY UPDATE lat=$lat, lng=$lng";


    if(mysqli_query($link, $sql)){
        echo "Records added successfully.";
    } else{
        echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
    }

    // close connection
    mysqli_close($link);
?>
