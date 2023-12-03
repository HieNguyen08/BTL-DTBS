<?php
include "db_conn.php";
session_start();
if (isset($_SESSION['id']) && isset($_SESSION['user'])) {

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
        <div class="container">
            <header>
                <div class="filterEntries">
                    <div class="filter">
                        <label for="search">Search:</label>
                        <input type="search" name="" id="search" placeholder="Enter Name/ Author">
                    </div>
                </div>
                <div class="addMemberBtn">
                    <button>New Document</button>
                </div>
            </header>
            <table>
                <thead>
                    <tr class="heading">
                        <th>ID</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Language</th>
                        <th>Author</th>
                        <th>Rating</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody class="userInfo">
                    <?php 
                        $sql = 
                        "SELECT D.*, R.Rating, L.dlanguage, CASE WHEN D.Document_ID = B.Document_ID THEN 'Book' ELSE 'Journal' end as 'Type', GROUP_CONCAT(A.Author, ', ') AS Author
                        FROM documents AS D
                        LEFT JOIN review_comments AS R ON R.Document_ID = D.Document_ID 
                        LEFT JOIN documents_language AS L ON L.Document_ID = D.Document_ID
                        LEFT JOIN books AS B ON B.Document_ID = D.Document_ID,
                        books_author AS A
                        GROUP BY D.Document_ID;";
                        $result = $conn->query($sql);
                        
                        if (!$result) {
                            die('Invalid query: '. $conn->error);
                        }

                        while ($row = $result->fetch_assoc()) {
                            echo 
                            "<tr class = 'employeeDetails'>
                            <td>$row[Document_ID]</td>
                            <td>$row[DName]</td>
                            <td>$row[Type]</td>
                            <td>$row[dlanguage]</td>
                            <td>$row[Author]</td>
                            <td>$row[Rating]</td>
                            <td>
                                <button><i class='fa-regular fa-eye'></i></button>
                                <button><i class='fa-regular fa-pen-to-square'></i></button>
                                <button><i class='fa-regular fa-trash-can'></i></button>
                            </td>
                            </tr>";
                        }
                        ?>
                </tbody>
            </table>
        </div>
        <!--Popup Form-->
        <div class="dark_bg">
            <div class="popup">
                <header>
                    <h2 class="modalTitle">Fill the Form</h2>
                    <button class="closeBtn">&times;</button>
                </header>
                <div class="body">
                    <form action="#" id="myForm">
                        <div class="inputFieldContainer">
                            <div class="form_control">
                                <label for="name">Document Name:<h4>*</h4></label>
                                <input type="name" name="" id="name" required>
                            </div>
                            <div class="form_control">
                                <label for="type">Type:<h4>*</h4></label>
                                <div class="entries">
                                    <select name="" id="book_type">
                                        <option value="book">Book</option>
                                        <option value="journal">Journal</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form_control">
                                <label for="language">Language:<h4>*</h4></label>
                                <input type="name=" name="" id="language" required>
                            </div>
                            <div class="form_control">
                                <label for="author">Author:<h4>*</h4></label>
                                <input type="name=" name="" id="author" required>
                            </div>
                        </div>
                    </form>
                </div>
                <footer class="popupFooter">
                    <button form="myForm" class="submitBtn">Submit</button>
                </footer>
            </div>
        </div>
        <script src="main.js"></script>
    </body>
</html>
<?php 
}
else {
    header("location: index.php");
    exit();
} 
?>