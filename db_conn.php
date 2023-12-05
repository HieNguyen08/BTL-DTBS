<?php
$sname = "localhost";
$uname = "root";
$pass = "";


$db = "test";


$conn = mysqli_connect($sname, $uname, $pass, $db);

if (!$conn) {
    echo "Connection failed";
}