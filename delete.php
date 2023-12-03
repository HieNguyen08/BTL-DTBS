<?php
include "db_conn.php";
session_start();
if (isset($_SESSION['id']) && isset($_SESSION['user'])) {
    if (isset($_GET["id"])) {
        $id = $_GET["id"];

        $sql = "DELETE FROM documents WHERE Document_ID=$id";
        $conn->query($sql);
        header("location:home.php");
        exit();
    }
}