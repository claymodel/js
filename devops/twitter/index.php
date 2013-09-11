<?php 
session_start();
include_once('header.php');
include_once('functions.php');

$_SESSION['userid'] = 1;
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title>Microblogging Application</title>
</head>
vbody>

<?php
if (isset($_SESSION['message'])){
	echo "<b>". $_SESSION['message']."</b>";
	unset($_SESSION['message']);
}
?>
<form method='post' action='add.php'>
<p>Your status:</p>
<textarea name='body' rows='5' cols='40' wrap=VIRTUAL></textarea>
<p><input type='submit' value='submit'/></p>
</form>
<?php
$posts = show_posts($_SESSION['userid']);

if (count($posts)){
?>
<table border='1' cellspacing='0' cellpadding='5' width='500'>
<?php
foreach ($posts as $key => $list){
	echo "<tr valign='top'>\n";
	echo "<td>".$list['userid'] ."</td>\n";
	echo "<td>".$list['body'] ."<br/>\n";
	echo "<small>".$list['stamp'] ."</small></td>\n";
	echo "</tr>\n";
}
?>
</table>
<?php
}else{
?>
<p><b>You haven't posted anything yet!</b></p>
<?php
}
?>


<h2>Users you're following</h2>

<?php
$users = show_users($_SESSION['userid']);

if (count($users)){
?>
<ul>
<?php
foreach ($users as $key => $value){
	echo "<li>".$value."</li>\n";
}
?>
</ul>
<?php
}else{
?>
<p><b>You're not following anyone yet!</b></p>
<?php
}
?>
<?php
$users = show_users($_SESSION['userid']);
if (count($users)){
	$myusers = array_keys($users);
}else{
	$myusers = array();
}
$myusers[] = $_SESSION['userid'];

$posts = show_posts($myusers,5);
?>

        
</body>
</html>
