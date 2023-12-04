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
                <form class="filterEntries" action="search_member.php" method="get">
                    <div class="filter">
                        <label for="search">Search:</label>
                        <input action="member.php" type="search" id="search" name="search" placeholder="Enter Name/Author/Publisher">
                    </div>
                </form>
                <div class="addMemberBtn">
                    <a class="button" href="add_member.php"><button>New Member</button></a>
                </div>
            </header>
            <table class="sortable">
                <thead style="height:30px;">
                    <tr class="heading">
                        <th><button>ID<span aria-hidden="true"></span></button></th>
                        <th><button>First Name<span aria-hidden="true"></span></button></th>
                        <th><button>Last Name<span aria-hidden="true"></span></button></th>
                        <th><button>Gender<span aria-hidden="true"></span></button></th>
                        <th><button>Email<span aria-hidden="true"></span></button></th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody class="userInfo">
                <?php 
                    if ($search) {
                        // SQL query to search for members by ID, first name, or last name.
                        $sql = "SELECT * FROM members 
                                WHERE Member_ID LIKE '%{$search}%' 
                                OR First_Name LIKE '%{$search}%' 
                                OR Last_Name LIKE '%{$search}%'";
                    } else {
                        // The default SQL query if there's no search term.
                        $sql = "SELECT * FROM members";
                    }
                    $result = $conn->query($sql);

                    if ($result->num_rows > 0) {
                        // Output data of each row
                        while($row = $result->fetch_assoc()) {
                            echo "<tr class='memberDetails'>";
                            echo "<td>" . $row["Member_ID"] . "</td>";
                            echo "<td>" . htmlspecialchars($row["First_Name"]) . "</td>";
                            echo "<td>" . htmlspecialchars($row["Last_Name"]) . "</td>";
                            echo "<td>" . htmlspecialchars($row["Gender"]) . "</td>";
                            echo "<td>" . htmlspecialchars($row["Email"]) . "</td>";
                            echo "<td>
                                    <a class='button' href='edit_member.php?id=$row[Member_ID]'><button><i class='fa-regular fa-pen-to-square'></i></button></a>
                                    <a class='button' href='delete_member.php?id=$row[Member_ID]'><button><i class='fa-regular fa-trash-can'></i></button></a>
                                </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "0 results";
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