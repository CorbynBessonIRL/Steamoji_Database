<!doctype html>
<html>

<head>
    <title>Delete a Tutor</title>
    <link rel="stylesheet" href="../css/style.css" />
</head>

<body>

    <?php
    require 'config.php';

    try {
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        echo "<p style='color:green'>Connection Was Successful</p>";
    } catch (PDOException $err) {
        echo "<p style='color:red'> Connection Failed: " . $err->getMessage() . "</p>\r\n";
    }

    try {
        // first, check if the record exists for deleting. if it does not exist, display a message, else delete it.
        $sql = "SELECT TutorID FROM Tutor WHERE TutorID = :tid";
        $stmnt = $conn->prepare($sql);
        $stmnt->bindParam(':tid', $_POST['tutorId']);

        $stmnt->execute();

        if ($stmnt->rowCount() === 0) {
            echo "<p style='color:red'>Record not Found. Cannot Delete.</p>\r\n";
        } else {
            $sql = "DELETE FROM Tutor WHERE TutorID = :tid";
            $stmnt = $conn->prepare($sql);
            $stmnt->bindParam(':tid', $_POST['tutorId']);

            $stmnt->execute();
            echo "<p style='color:green'>Record Deleted Successfully</p>";
        }
    } catch (PDOException $err) {
        echo "<p style='color:red'>Record Delete Failed: " . $err->getMessage() . "</p>\r\n";
    }

    unset($conn);

    echo "<a href='../index.html'>Back to the Future!(Homepage)</a>";
    ?>

</body>

</html>
