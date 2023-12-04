<?php
include "db_conn.php";
session_start();

if (isset($_SESSION['id']) && isset($_SESSION['user'])) {
    if (isset($_GET["id"])) {
        $memberId = $_GET["id"];

        // Delete related data from other tables if necessary. For example:
        $sql = "DELETE FROM review_comments WHERE Member_ID=$memberId";
        $conn->query($sql);

        $sql = "DELETE FROM loans WHERE Member_ID=$memberId";
        $conn->query($sql);

        $sql = "DELETE FROM members_phone WHERE Member_ID=$memberId";
        $conn->query($sql);

        $sql = "DELETE FROM vouchers WHERE Member_ID=$memberId";
        $conn->query($sql);

        // Finally, delete the member record
        $sql = "DELETE FROM members WHERE Member_ID=$memberId";
        $conn->query($sql);

        header("location:member.php");
        exit();
    }
}
?>
