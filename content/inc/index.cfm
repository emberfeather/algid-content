<!--- Create URL object from the factory --->
<cfset theURL = application.managers.factory.getURL(CGI.QUERY_STRING) />

<!--- TODO Find actual location --->

<!--- TODO Process request --->

<!--- TODO Create template object --->

<!--- TODO Include Template File --->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title>Poseidon Content Plugin</title>
		<link rel="stylesheet" href="style/frontAdmin.css" type="text/css"/>
	</head>
	<body>
		What now?
		
		<!--- TODO Remove --->
		<cfdump var="#application#" />
		
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
		<script type="text/javascript" src="script/frontAdmin.js"></script>
	</body>
</html>