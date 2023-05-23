<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* request parameter values 유효성 검사
	* noticeNo의 값이 null, "" 이면 noticeList.jsp 페이지로 리턴
	*/
	if(request.getParameter("noticeNo")==null
		||request.getParameter("noticeNo").equals("")){
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 디버깅 코드(parameter 값을 받았는지 확인)
	System.out.println(noticeNo + "deleteNoticeForm param noticeNo"); 
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a {text-decoration: none;}
	a.btn{
    display:inline-block;
    width:100px;
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
    color:#FFFFFF;}
    .none {border-style:none;}
    .right{text-align:right;}
</style>
<title>deleteNoticeForm</title>
</head>
<body>
	<div class="container p-3"><!-- 메인메뉴 -->
		<a href="./home.jsp" class="btn">홈</a>
		<a href="./noticeList.jsp" class="btn">공지</a>
		<a href="./scheduleList.jsp" class="btn">일정</a>
	</div>
	<div class="container p-3">
		<!-- deleteNoticeAction.jsp 페이지에서 유효성 검사시 msg!=null 때 msg를 출력 -->
		<%
			String msg = request.getParameter("msg");
			if(msg!= null){
		%>
				<%=msg%>
		<%		
			}
		%>
	</div>
	<form action="./deleteNoticeAction.jsp" method="post">
		<div class="container">
		<h3>공지 삭제</h3>
		<table class="table table-sm">
			<tr>
				<td>번호</td>
				<td>
					<!-- hidden : 안보이게 -->
					<!-- <input type="hidden" name="noticeNo" value="<%=noticeNo%>"> -->
					<input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly" class="none">
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
			<button type="submit" class="btn">삭제</button>
		</div>
	</form>
</body>
</html>