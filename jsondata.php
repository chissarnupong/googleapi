<?php

  header('Content-Type: application/json');
  $objConnect = mysqli_connect("localhost", "root", "", "map");
  $strSQL = "SELECT * FROM maping";
  $objQuery = mysqli_query($objConnect,$strSQL);
  $resultArray = array();
  while($obResult = mysqli_fetch_assoc($objQuery))
  {
  array_push($resultArray, $obResult);
  }
  echo json_encode($resultArray);

?>
