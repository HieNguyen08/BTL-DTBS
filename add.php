<?php
include "db_conn.php";
session_start();
if (isset($_SESSION['id']) && isset($_SESSION['user'])) {
    $name = "";
    $language = "";
    $type = "";
    $author = "";
    $ID = 1;

    $success = "";

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $name = $_POST["name"];
        $language = $_POST["language"];
        $type = $_POST["type"];
        $author = $_POST["author"];

        $sql = "INSERT INTO documents(DName, Document_ID) VALUES (?, ?)";
        $stmt1 = $conn->prepare($sql);
        switch ($type) {
            case "book" :
                $sql = "INSERT INTO books(Document_ID) VALUES (?)";
                $stmt2 = $conn->prepare($sql);
                $sql = "INSERT INTO books_author(Author, Document_ID) VALUES (?, ?)";
                $stmt4 = $conn->prepare($sql);
                break;
            case "journal":
                $sql = "INSERT INTO journals(Document_ID) VALUES (?)";
                $stmt2 = $conn->prepare($sql);
                $sql = "INSERT INTO published_by(Document_ID, Publisher_ID) VALUES (?, ?)";
                $stmt4 = $conn->prepare($sql);
                $sql = "INSERT INTO publishers(Publisher_ID, pname) VALUES (?. ?)";
                $stmt5 = $conn->prepare($sql);
                break;
        }
        $sql = "INSERT INTO documents_language(dlanguage, Document_ID) VALUES (?, ?)";
        $stmt3 = $conn->prepare($sql);

        // Check if the statement was prepared successfully
        if ($stmt1 && $stmt2 && $stmt3 && $stmt4) {
            // Bind parameters and execute the statement
            $stmt1->bind_param("ss", $name, $ID);
            $stmt1->execute();
            $stmt2->bind_param("s", $ID);
            $stmt2->execute();
            $stmt3->bind_param("ss", $language, $ID);
            $stmt3->execute();
            switch ($type) {
                case "book" :
                    $stmt4->bind_param("ss", $author, $ID);
                    $stmt4->execute();
                    break;
                case "journal":
                    $stmt4->bind_param("ss", $ID, $ID);
                    $stmt4->execute();
                    $stmt5->bind_param("ss", $ID, $author);
                    $stmt5->execute();
                    break;
            }
            // Check if the execution was successful
            if ($stmt1->affected_rows > 0 && $stmt2->affected_rows > 0 && $stmt3->affected_rows > 0) {
                $success = "Document Added";
            }
            // Close the statement
            $stmt1->close();
            $stmt2->close();
            $stmt3->close();
        } else {
            $success = "Error preparing statement: " . $conn->error;
        }
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
                                <label for="author">Author/Publisher:<h4>*</h4></label>
                                <input type="name=" name="author" id="author" value="<?php echo $author ?>" required>
                            </div>
                        </div>
                    </form>
                </div>
                <footer class="popupFooter">
                <?php if ($success) { echo $success; } ?>
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