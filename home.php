<?php
include "db_conn.php";
session_start();
if (isset($_SESSION['id']) && isset($_SESSION['user'])) {
    $search = $_GET["search"]
?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>View</title>
        <link rel="stylesheet" href="style.css">
        <link rel="stylesheet" href="login.css">
        <link rel="stylesheet" href="table.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css" integrity="sha512-MV7K8+y+gLIBoVD59lQIYicR65iaqukzvf/nwasF0nqhPay5w/9lJmVM2hMDcnK1OnMGCdVK+iQrJ7lzPJQd1w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <style>
    
        nav {
            display: flex;
            justify-content: center;
            background-color: #004d99; /* Dark blue background */
            padding: 10px;
            border-radius: 5px; /* Rounded corners */
        }

        nav a {
            margin: 0 15px;
            text-decoration: none;
            color: #fff; /* White text */
            font-weight: bold;
            transition: color 0.3s ease; /* Smooth color transition */
        }

        nav a:hover {
            color: #ffd700; /* Gold color on hover */
        }

    /* Keeping the 'Log Out' button style unchanged */
    </style>
    <body style="flex-direction: column;">
        <div class="header">
            <h2 class="logo">Database</h2>
            <nav class="nagivation">
                <a class="button" href="logout.php"><button class="btnlogout">Log Out</button></a>
            </nav>
        </div>
        <nav>
            <a href="home.php">Manage Document</a>
            <a href="member.php">Manage Member</a>
        </nav>
        <div class="container">
            <header>
                <form class="filterEntries" action="search.php" method="get">
                    <div class="filter">
                        <label for="search">Search:</label>
                        <input action="home.php" type="search" id="search" name="search" placeholder="Enter Name/Author/Publisher">
                    </div>
                </form>
                <div class="addMemberBtn">
                    <a class="button" href="add.php"><button>New Document</button></a>
                </div>
            </header>
            <table class="sortable">
                <thead style="height:30px;">
                    <tr class="heading">
                        <th><button>ID<span aria-hidden="true"></span></button></th>
                        <th><button>Name<span aria-hidden="true"></span></button></th>
                        <th><button>Type<span aria-hidden="true"></span></button></th>
                        <th><button>Language<span aria-hidden="true"></span></button></th>
                        <th><button>Author/Publisher<span aria-hidden="true"></span></button></th>
                        <th><button>Rating<span aria-hidden="true"></span></button></th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody class="userInfo">
                    <?php 
                        if ($search) {
                        $sql = 
                        "SELECT D.*, L.dlanguage, CASE WHEN D.Document_ID = B.Document_ID THEN 'Book' ELSE 'Journal' END AS 'Type', 
                        CASE WHEN D.Document_ID = A.Document_ID THEN A.Author WHEN D.Document_ID = Pb.Document_ID THEN  P.pname END AS 'Author'
                        FROM documents AS D 
                        LEFT JOIN documents_language AS L ON L.Document_ID = D.Document_ID 
                        LEFT JOIN books AS B ON B.Document_ID = D.Document_ID 
                        LEFT JOIN books_author AS A ON A.Document_ID = D.Document_ID
                        LEFT JOIN published_by AS Pb ON Pb.Document_ID = D.Document_ID 
                        LEFT JOIN  publishers AS P ON Pb.Publisher_ID = P.Publisher_ID
                        WHERE D.Dname LIKE '%{$search}%' OR P.pname LIKE '%{$search}%' OR A.Author LIKE '%{$search}%'
                        GROUP BY D.Document_ID;";}
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
                        GROUP BY D.Document_ID;"; 
                        }
                        $result = $conn->query($sql);
                        while ($row = $result->fetch_assoc()) {
                            $rating = $conn->query("SELECT AverageRating($row[Document_ID]);")->fetch_assoc()["AverageRating($row[Document_ID])"];
                            echo 
                            "<tr class = 'employeeDetails'>
                            <td>$row[Document_ID]</td>
                            <td>$row[DName]</td>
                            <td>$row[Type]</td>
                            <td>$row[dlanguage]</td>
                            <td>$row[Author]</td>
                            <td>$rating</td>
                            <td>
                                <a class='button' href='edit.php?id=$row[Document_ID]'><button><i class='fa-regular fa-pen-to-square'></i></button></a>
                                <a class='button' href='delete.php?id=$row[Document_ID]'><button><i class='fa-regular fa-trash-can'></i></button></a>
                            </td>
                            </tr>";
                        }
                        ?>
                </tbody>
            </table>
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