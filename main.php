<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>View</title>
    <style>
        /* Basic Styling */
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            font-family: 'Arial', sans-serif;
        }

        .header,
        .footer {
            background-color: #004d99;
            color: white;
            padding: 20px;
            text-align: center;
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1,
        .footer h1 {
            margin: 0;
        }

        nav {
            display: flex;
            justify-content: center;
            background-color: #004d99;
            padding: 10px;
            border-radius: 5px;
            width: 100%;
            margin-top: 20px;
        }

        nav a {
            text-decoration: none;
            color: #fff;
            font-weight: bold;
            transition: color 0.3s ease;
            padding: 10px 20px;
            border-radius: 5px;
        }

        nav a:hover {
            color: #ffd700;
        }

        .logout-btn {
            background-color: #004d99;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .logout-btn:hover {
            background-color: #002040;
        }

        .content {
            flex-grow: 1;
            text-align: center;
            padding: 40px;
        }

        .instruction-box {
            border: 2px solid #004d99;
            border-radius: 10px;
            padding: 30px;
            margin-top: 40px;
            background-color: #f4f4f4;
            text-align: left;
        }

        .instruction-box h3 {
            color: #004d99;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .instruction-box p {
            font-size: 18px;
            line-height: 1.5;
            margin-bottom: 15px;
        }

        .instruction-box ul {
            list-style-type: none;
            padding: 0;
            margin-top: 15px;
        }

        .instruction-box li {
            font-size: 16px;
            margin-bottom: 10px;
        }

        .feedback-box {
            border: 2px solid #004d99;
            border-radius: 10px;
            padding: 20px;
            margin-top: 40px;
            background-color: #f4f4f4;
            text-align: center;
        }

        .feedback-box h3 {
            color: #004d99;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .feedback-form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .feedback-form label {
            margin-bottom: 10px;
            font-size: 18px;
        }

        .feedback-form textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 16px;
        }

        .feedback-form button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #004d99;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>

<body>
    <div class="header">
        <h1 class="logo">Database</h1>
        <button class="logout-btn">Log Out</button>
    </div>

    <nav>
        <a href="home.php">Manage Document</a>
        <a href="member.php">Manage Member</a>
    </nav>

    <div class="content">
        <!-- Nội dung trang web ở đây -->

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
