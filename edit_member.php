<?php
include "db_conn.php";
session_start();

if (isset($_SESSION['id']) && isset($_SESSION['user'])) {
    $firstName = "";
    $lastName = "";
    $gender = "";
    $email = "";
    $memberID = $_GET["id"];

    $success = "";
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $firstName = $_POST["firstName"];
        $lastName = $_POST["lastName"];
        $gender = $_POST["gender"];
        $email = $_POST["email"];

        $sql = "UPDATE members SET First_Name = ?, Last_Name = ?, Gender = ?, Email = ? WHERE Member_ID = $memberID";
        $stmt = $conn->prepare($sql);

        if ($stmt) {
            $stmt->bind_param("ssss", $firstName, $lastName, $gender, $email);
            $stmt->execute();
            $stmt->close();
            $success = "Member updated successfully!";
        } else {
            $success = "Error preparing statement: " . $conn->error;
        }
    } else {
        $sql = "SELECT * FROM members WHERE Member_ID = '$memberID'";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();

        $firstName = $row["First_Name"];
        $lastName = $row["Last_Name"];
        $gender = $row["Gender"];
        $email = $row["Email"];
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
                    <a class="button" href="member.php"><button class="closeBtn">&times;</button></a>
                </header>
            <form method="post">
                <input type="hidden" value="<?php echo $memberID ?>">
                <div class="inputFieldContainer">
                    <div class="form_control">
                        <label for="firstName">First Name:<h4>*</h4></label>
                        <input type="text" name="firstName" id="firstName" value="<?php echo $firstName ?>" required>
                    </div>
                    <div class="form_control">
                        <label for="lastName">Last Name:<h4>*</h4></label>
                        <input type="text" name="lastName" id="lastName" value="<?php echo $lastName ?>" required>
                    </div>
                    <div class="form_control">
                        <label for="gender">Gender:<h4>*</h4></label>
                        <input type="text" name="gender" id="gender" value="<?php echo $gender ?>" required>
                    </div>
                    <div class="form_control">
                        <label for="email">Email:<h4>*</h4></label>
                        <input type="email" name="email" id="email" value="<?php echo $email ?>" required>
                    </div>
                </div>
            </form>
            <footer class="popupFooter">
                <?php if ($success) echo $success; ?>
                <button type="submit" class="submitBtn">Submit</button>
            </footer>
    </body>
</html>
<?php 
} else {
    header("location: index.php");
    exit();
} 
?>
