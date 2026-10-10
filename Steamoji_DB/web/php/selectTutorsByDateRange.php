<!doctype html>
<html>

<head>
    <title>Display Tutors</title>
    <link rel="stylesheet" href="../css/style.css" />
</head>

<body>

    <?php
    $servername = "localhost";
    $dbname = "Steamoji";
    $username = "root";
    $password = "";

    try {
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        echo "<p style='color:green'>Connection Was Successful</p>";
    } catch (PDOException $err) {
        echo "<p style='color:red'> Connection Failed: " . $err->getMessage() . "</p>\r\n";
    }

    try {
        $sql = "SELECT TutorID, FirstName, LastName, DateOfBirth, HighestDegree FROM Tutor WHERE DateOfBirth BETWEEN :startDate AND :endDate";
        $stmnt = $conn->prepare($sql);
        $stmnt->bindParam(':startDate', $_POST['startDate']);
        $stmnt->bindParam(':endDate', $_POST['endDate']);

        $stmnt->execute();

        $row = $stmnt->fetch();
        if ($row) {
            echo '<table>';
            echo '<tr> <th>TutorID</th> <th>First Name</th> <th>Last Name</th> <th>Date of Birth</th> <th>Highest Degree</th> </tr>';
            do {
                echo "<tr><td>$row[TutorID]</td><td>$row[FirstName]</td><td>$row[LastName]</td><td>$row[DateOfBirth]</td><td>$row[HighestDegree]</td></tr>";
            } while ($row = $stmnt->fetch());
            echo '</table>';
        } else {
            echo "<p> No Record Found!</p>";
        }
    } catch (PDOException $err) {
        echo "<p style='color:red'>Record Retrieval Failed: " . $err->getMessage() . "</p>\r\n";
    }

    unset($conn);

    echo "<a href='../index.html'>Back to the Future!(Homepage)</a>";
    ?>
</body>

</html>
