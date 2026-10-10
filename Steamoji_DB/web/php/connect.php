<!doctype html>
<html>

<head>
	<title>Connect to a Database</title>
	<link rel="stylesheet" href="../css/style.css" />
</head>

<body>

	<?php
	require 'config.php';

	try {
		$conn = new PDO("mysql:host=$servername", $username, $password);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		echo "<p style='color:green'>Connection Was Successful</p>";
	} catch (PDOException $err) {
		echo "<p style='color:red'>Connection Failed: " . $err->getMessage() . "</p>";
	}

	unset($conn);

	echo "<a href='../index.html'>Back to the Future!(Homepage)</a>";
	?>

</body>

</html>
