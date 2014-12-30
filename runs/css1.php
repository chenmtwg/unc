<!DOCTYPE html>
<html >
<head>
<style type="text/css">
.button
{
	width: 150px;
	padding: 10px;
	background-color: #FF8C00;
	box-shadow: -8px 8px 10px 3px rgba(0,0,0,0.2);
    font-weight:bold;
	text-decoration:none;
}
#cover{
    position:fixed;
    top:0;
    left:0;
    background:rgba(0,0,0,0.6);
    z-index:5;
    width:100%;
    height:100%;
    display:none;
}
#loginScreen
{
    height:70%;
    width:100%;
    margin:0 auto;
    position:relative;
    z-index:10;
    display:none;
	background: url(login.png) no-repeat;
	border:5px solid #cccccc;
	border-radius:10px;
}
#mainscreen
{
    height:70%;
    width:100%;
    top:30px;
    margin:0 auto;
    position:relative;
    z-index:10;
	background: url(login.png) no-repeat;
}
#loginScreen:target, #loginScreen:target + #cover{
    display:block;
    opacity:2;
}
.cancel
{
    display:block;
    position:absolute;
    top:0px;
    right:0px;
    background:rgb(245,245,245);
    color:black;
    height:30px;
    width:35px;
    font-size:30px;
    text-decoration:none;
    text-align:center;
    font-weight:bold;
}
</style>
</head>
<body>
<div align="center">
	<br><br><br><br>
	<a href="#loginScreen" onclick="makeLink()" class="button">Click here to Log In</a>
</div>
<span id="loginScreen">
    <a href="#" class="cancel">&times;</a><div id='mainscreen'>aaaa</div>
</span>
<div id="cover" >
</div>
<script language=javascript> 
 function makeLink(){
	var link = new XMLHttpRequest();
	link.onreadystatechange=function(){
		if(link.readyState==4 && link.status==200){
		document.getElementById("mainscreen").innerHTML=link.responseText;

        }}
        link.open("GET","/");
        link.send()
 }
</script>
	
</body>
</html>
