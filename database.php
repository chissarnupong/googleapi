<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "map";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

// sql to create table
$info = "CREATE TABLE info (
name VARCHAR(30)  , 
src VARCHAR(30) ,
tim INT(6) ,
sig INT(6) NOT NULL,
tst INT(6) NOT NULL,
reg_date TIMESTAMP,
primary key (name, src, tim)
)";

$maping = "CREATE TABLE maping (
    name VARCHAR(30) PRIMARY KEY, 
    lat VARCHAR(30) NOT NULL,
    lng VARCHAR(30) NOT NULL,
    reg_date TIMESTAMP
    )";

$conn->query($info) ;
$conn->query($maping) ;

// if ($conn->query($info2) === TRUE) {
//     echo "Table MyGuests created successfully";
// } else {
//     echo "Error creating table: " . $conn->error;
// }

$conn->close();
?>