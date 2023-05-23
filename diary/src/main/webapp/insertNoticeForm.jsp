<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a {text-decoration: none;}
	a.btn{
    display:inline-block;
    width:80px;
    line-height:20px;
    text-align:center;
    background-color:#333333;
    color:#FFFFFF;}
    button.btn{
    display:inline-block;
    width:80px;
    line-height:20px;
    text-align:center;
    background-color:#333333;
    color:#FFFFFF;}s
</style>
</head>
<body>
	<div class="container p-3"><!-- 메인메뉴 -->
		<a href="./home.jsp" class="btn">홈</a>
		<a href="./noticeList.jsp" class="btn">공지</a>
		<a href="./scheduleList.jsp" class="btn">일정</a>
	</div>
	<div class="container p-3">
		<%
			// insertNoticeAction.jsp 페이지에서 들어온 msg의 값이 null이 아니면 msg 출력
			String msg = request.getParameter("msg");
			if(msg!= null){
		%>
				<%=msg%>
		<%		
			}
		%>
	</div>
	<form action="./insertNoticeAction.jsp" method="post">
		<div class="container p-3">
		<h3>공지 입력</h3>
			<table class="table table=sm">
				<tr>
					<td>제목</td>
					<td>
						<input type="text" name="noticeTitle">
					</td>
				</tr>
				<tr>
					<td>공지</td>
					<td>
						<textarea rows="5" cols="80" name="noticeContent"></textarea>
					</td>
				</tr>
				<tr>
					<td>작성인</td>
					<td>
						<input type="text" name="noticeWriter">
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" name="noticePw">
					</td>
				</tr>
			</table>
		</div>
		<div class="container right">
			<button type="submit" class="btn">입력</button>
		</div>
	</form>
</body>
</html>