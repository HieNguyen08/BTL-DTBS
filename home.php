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
                        <label for="type">Sort by:</label>
                        <div class="entries">
                            <select name="" id="sort">
                                <option value="1">ID Ascending</option>
                                <option value="2">ID Descending</option>
                                <option value="2">Name Descending</option>
                                <option value="2">Name Descending</option>
                                <option value="2">Highest Rating</option>
                            </select>
                        </div>
                    </div>
                    <div class="filter">
                        <label for="search">Search:</label>
                        <input action="home.php" type="search" id="search" placeholder="Enter Name/ Author">
                    </div>
                </div>
                <div class="addMemberBtn">
                    <a class="button" href="add.php"><button>New Document</button></a>
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
                        "SELECT D.*, AVG(R.Rating) AS Rating, L.dlanguage, CASE WHEN D.Document_ID = B.Document_ID THEN 'Book' ELSE 'Journal' end as 'Type', GROUP_CONCAT(A.Author, ', ') AS Author
                        FROM books_author AS A, documents AS D
                        LEFT JOIN review_comments AS R ON R.Document_ID = D.Document_ID 
                        LEFT JOIN documents_language AS L ON L.Document_ID = D.Document_ID
                        LEFT JOIN books AS B ON B.Document_ID = D.Document_ID
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
                                <a class='button' href='delete.php?id=$row[Document_ID]'><button><i class='fa-regular fa-trash-can'></i></button></a>
                            </td>
                            </tr>";
                        }
                        ?>
                </tbody>
            </table>
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