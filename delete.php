<?php
include "db_conn.php";
session_start();
if (isset($_SESSION['id']) && isset($_SESSION['user'])) {
    if (isset($_GET["id"])) {
        $id = $_GET["id"];

        $sql = "DELETE FROM books WHERE Document_ID=$id";
        $conn->query($sql);
        $sql = "DELETE FROM book_author WHERE Document_ID=$id";
        $conn->query($sql);
        $sql = "DELETE FROM documents WHERE Document_ID=$id";
        $conn->query($sql);
        $sql = "DELETE FROM documents_language WHERE Document_ID=$id";
        $conn->query($sql);
        $sql = "DELETE FROM review_comments WHERE Document_ID=$id";
        $conn->query($sql);
        $sql = "DELETE FROM published_by WHERE Document_ID=$id";
        $conn->query($sql);
        $sql = "DELETE FROM publishers WHERE Document_ID=(SELECT Document_ID published_by WHERE Document_ID=$id)";
        $conn->query($sql);
        header("location:home.php");
        exit();
    }
}