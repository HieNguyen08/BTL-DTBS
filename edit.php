<?php
include "db_conn.php";
session_start();
if (isset($_SESSION['id']) && isset($_SESSION['user'])) {
    $name = "";
    $language = "";
    $type = "";
    $author = "";
    $ID = $_GET["id"];

    $success = "";
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $name = $_POST["name"];
        $language = $_POST["language"];
        $type = $_POST["type"];
        $author = $_POST["author"];

        $sql = "UPDATE documents SET Dname = ? WHERE Document_ID = $ID";
        $stmt1 = $conn->prepare($sql);
        switch ($type) {
            case "book" :
                $sql = "UPDATE books_author SET Author = ? WHERE Document_ID = $ID";
                $stmt4 = $conn->prepare($sql);
                break;
            case "journal":
                $sql = "UPDATE publishers SET pname = ? WHERE Publisher_ID = $ID";
                $stmt4 = $conn->prepare($sql);
                break;
        }
        $sql = "UPDATE documents_language SET dlanguage = ? WHERE Document_ID = $ID";
        $stmt3 = $conn->prepare($sql);

        // Check if the statement was prepared successfully
        if ($stmt1 && $stmt3 && $stmt4) {
            // Bind parameters and execute the statement
            $stmt1->bind_param("s", $name);
            $stmt1->execute();
            $stmt3->bind_param("s", $language);
            $stmt3->execute();
            switch ($type) {
                case "book" :
                    $stmt4->bind_param("s", $author);
                    $stmt4->execute();
                    break;
                case "journal":
                    $stmt4->bind_param("s", $author);
                    $stmt4->execute();
                    break;
            }
            $stmt1->close();
            $stmt3->close();
            $stmt4->close();
        } else {
            $success = "Error preparing statement: " . $conn->error;
        }
    }
    else {
        $sql = 
            "SELECT D.*, L.dlanguage, CASE WHEN D.Document_ID = B.Document_ID THEN 'Book' ELSE 'Journal' END AS 'Type', 
            CASE WHEN D.Document_ID = A.Document_ID THEN A.Author WHEN D.Document_ID = Pb.Document_ID THEN  P.pname END AS 'Author'
            FROM documents AS D 
            LEFT JOIN documents_language AS L ON L.Document_ID = D.Document_ID 
            LEFT JOIN books AS B ON B.Document_ID = D.Document_ID 
            LEFT JOIN books_author AS A ON A.Document_ID = D.Document_ID
            LEFT JOIN published_by AS Pb ON Pb.Document_ID = D.Document_ID 
            LEFT JOIN  publishers AS P ON Pb.Publisher_ID = P.Publisher_ID
            WHERE D.Document_ID = '$ID'
            GROUP BY D.Document_ID;";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
    
        $name = "$row[DName]";
        $language = "$row[dlanguage]";
        $type = "$row[Type]";
        $author = "$row[Author]";
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
                        <input type="hidden" value="<?php echo $ID ?>">
                        <div class="inputFieldContainer">
                            <div class="form_control">
                                <label for="name">Document Name:<h4>*</h4></label>
                                <input type="name" name="name" id="name" value="<?php echo $name ?>" required>
                            </div>
                            <div class="form_control">
                                <label for="type">Type:<h4>*</h4></label>
                                <div class="entries">
                                    <select name='type' id='book_type' value='<?php echo $type ?> disabled'>
                                        <option value='book'>Book</option>
                                        <option value='journal'>Journal</option>
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
                <?php 
                if ($success) {
                    echo $success;
                }
                ?>
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