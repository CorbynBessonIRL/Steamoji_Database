<!doctype html>
<html>

<head>
	<title>Insert a Tutor</title>
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
		echo "<p style='color:red'>Connection Failed: " . $err->getMessage() . "</p>\r\n";
	}

	try {
		$sql = "INSERT INTO Tutor (TutorID, FirstName, LastName, DateOfBirth, HighestDegree) VALUES (:tid, :fn, :ln, :dob, :deg)";
		$stmnt = $conn->prepare($sql);
		$stmnt->bindParam(':tid', $_POST['tutorId']);
		$stmnt->bindParam(':fn', $_POST['fname']);
		$stmnt->bindParam(':ln', $_POST['lname']);
		$stmnt->bindParam(':dob', $_POST['dob']);
		$stmnt->bindParam(':deg', $_POST['degree']);

		$stmnt->execute();

		echo "<p style='color:green'>Tutor Inserted Successfully</p>";
	} catch (PDOException $err) {
		echo "<p style='color:red'>Insertion Failed: " . $err->getMessage() . "</p>\r\n";
	}

	unset($conn);

	echo "<a href='../insertTutor.html'>Insert Another Tutor</a> <br />";
	echo "<a href='../index.html'>Back to the Future!(Homepage)</a>";
	?>

</body>

</html>
