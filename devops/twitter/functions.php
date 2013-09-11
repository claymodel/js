<?php

function add_post($userid,$body){
	$sql = "insert into posts (user_id, body, stamp) 
			values ($userid, '". mysql_real_escape_string($body). "',now())";

	$result = mysql_query($sql);
}

                
function show_posts($userid,$limit=0){
	$posts = array();

	$user_string = implode(',', $userid);
	$extra =  " and id in ($user_string)";

	if ($limit > 0){
		$extra = "limit $limit";
	}else{
		$extra = '';	
	}

	$sql = "select user_id,body, stamp from posts 
		where user_id in ($user_string) 
		order by stamp desc $extra";
	echo $sql;
	$result = mysql_query($sql);

	while($data = mysql_fetch_object($result)){
		$posts[] = array( 	'stamp' => $data->stamp, 
							'userid' => $data->user_id, 
							'body' => $data->body
					);
	}
	return $posts;

}


function show_users($user_id=0){

	if ($user_id > 0){
		$follow = array();
		$fsql = "select user_id from following
				where follower_id='$user_id'";
		$fresult = mysql_query($fsql);

		while($f = mysql_fetch_object($fresult)){
			array_push($follow, $f->user_id);
		}

		if (count($follow)){
			$id_string = implode(',', $follow);
			$extra =  " and id in ($id_string)";

		}else{
			return array();
		}

	}

	$users = array();
	$sql = "select id, username from users 
		where status='active' 
		$extra order by username";


	$result = mysql_query($sql);

	while ($data = mysql_fetch_object($result)){
		$users[$data->id] = $data->username;
	}
	return $users;
}

function following($userid){
	$users = array();

	$sql = "select distinct user_id from following
			where follower_id = '$userid'";
	$result = mysql_query($sql);

	while($data = mysql_fetch_object($result)){
		array_push($users, $data->user_id);

	}

	return $users;

}

function check_count($first, $second){
	$sql = "select count(*) from following 
			where user_id='$second' and follower_id='$first'";
	$result = mysql_query($sql);

	$row = mysql_fetch_row($result);
	return $row[0];

}

function follow_user($me,$them){
	$count = check_count($me,$them);

	if ($count == 0){
		$sql = "insert into following (user_id, follower_id) 
				values ($them,$me)";

		$result = mysql_query($sql);
	}
}


function unfollow_user($me,$them){
	$count = check_count($me,$them);

	if ($count != 0){
		$sql = "delete from following 
				where user_id='$them' and follower_id='$me'
				limit 1";

		$result = mysql_query($sql);
	}
}
?>
