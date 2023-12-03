<?php
include "db_conn.php";
session_start();
if (isset($_SESSION['id']) && isset($_SESSION['user'])) {
    $name = "";
    $language = "";
    $type = "";
    $author = "";

    $success = "";

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $name = $_POST["name"];
        $language = $_POST["language"];
        $type = $_POST["type"];
        $author = $_POST["author"];
        do {
            $name = "";
            $language = "";
            $type = "";
            $author = "";

            $success = "Document Added";

            $sql = 
            "INSERT INTO documents (name)
            VALUES ('$name')";
            $result = $conn->query($sql);
        } while (false);        
    }
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>View</title>
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="login.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css" integrity="sha512-MV7K8+y+gLIBoVD59lQIYicR65iaqukzvf/nwasF0nqhPay5w/9lJmVM2hMDcnK1OnMGCdVK+iQrJ7lzPJQd1w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body style="flex-direction: column;">
        <div class="header">
            <h2 class="logo">Database</h2>
            <nav class="nagivation">
                <a class="button" href="logout.php"><button class="btnlogout">Log Out</button></a>
            </nav>
        </div>
        <div class="dark_bg active">
            <div class="popup active">
                <header>
                    <h2 class="modalTitle">Fill the Form</h2>
                    <a class="button" href="home.php"><button class="closeBtn">&times;</button></a>
                </header>
                <div class="body">
                    <form method="post" id="myForm">
                        <div class="inputFieldContainer">
                            <div class="form_control">
                                <label for="name">Document Name:<h4>*</h4></label>
                                <input type="name" name="name" id="name" value="<?php echo $name ?>" required>
                            </div>
                            <div class="form_control">
                                <label for="type">Type:<h4>*</h4></label>
                                <div class="entries">
                                    <select name="type" id="book_type" value="<?php echo $type ?>">
                                        <option value="book">Book</option>
                                        <option value="journal">Journal</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form_control">
                                <label for="language">Language:<h4>*</h4></label>
                                <input type="name=" name="language" id="language" value="<?php echo $language ?>" required>
                            </div>
                            <div class="form_control">
                                <label for="author">Author:<h4>*</h4></label>
                                <input type="name=" name="author" id="author" value="<?php echo $author ?>" required>
                            </div>
                        </div>
                    </form>
                </div>
                <footer class="popupFooter">
                    <button form="myForm" class="submitBtn" type="Submit">Submit</button>
                </footer>
            </div>
        </div>
    </body>
</html>
<?php 
}
else {
    header("location: index.php");
    exit();
} 
?>