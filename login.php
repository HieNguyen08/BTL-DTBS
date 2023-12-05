<?php
session_start();
include "db_conn.php";
if (isset($_POST['username']) && isset($_POST['password'])) {
    function validate($data) {
        $data = trim($data);
        $data = stripslashes($data);
        $data = htmlspecialchars($data);
        return $data;
    }
    $user = validate($_POST['username']);
    $pass = validate($_POST['password']);
    $sql = "select * from admin where user='$user' and pass='$pass'";
    $result = mysqli_query($conn, $sql);
    if (mysqli_num_rows($result)) {
        $row = mysqli_fetch_assoc($result);
        if ($row['user'] === $user and $row['pass'] === $pass) {
            $_SESSION['user'] = $row['user'];
            $_SESSION['pass'] = $row['pass'];
            $_SESSION['id'] = $row['ID'];

            header("location: main.php");

            exit();
        }
    }
}
header("location: index.php");
exit();