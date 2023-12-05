<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>View</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="login.css">
</head>

<body style="flex-direction: column;">
        <div class="header">
            <h2 class="logo">Database</h2>
            <nav class="nagivation">
                <a href="home.php">Manage Document</a>
                <a href="member.php">Manage Member</a>
                <a class="button" href="logout.php"><button class="btnlogout">Log Out</button></a>
            </nav>
        </div>
    <div class="content">

        <div class="instruction-box">
            <h3>How to use this website</h3>
            <p>Welcome to our website! Here are some instructions on how to navigate and use the features:</p>
            <ul>
                <li>Click on "Manage Document" to view and manage documents.</li>
                <li>Click on "Manage Member" to view and manage members.</li>
                <li>Use the search bar to find specific documents or members.</li>
                <li>Click on the "Log Out" button to log out of your account.</li>
            </ul>
        </div>

        <div class="feedback-box">
            <h3>Are you satisfied with our service?</h3>
            <form class="feedback-form">
                <label for="feedback">Please provide your feedback:</label>
                <textarea id="feedback" name="feedback" rows="4" placeholder="Enter your feedback here..."></textarea>
                <button type="submit">Submit Feedback</button>
            </form>
        </div>
    </div>

    <div class="footer">
        &copy; 2023 Your Company Name
    </div>

    <script src="main.js"></script>
</body>

</html>
