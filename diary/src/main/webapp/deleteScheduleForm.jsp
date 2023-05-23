<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청값 유효성 검사
	// 값이 null,"" 이면 scheduleList.jsp 페이지로 리턴
	if(request.getParameter("scheduleNo")==null
		|| request.getParameter("scheduleDate")==null
		|| request.getParameter("scheduleNo").equals("")
		|| request.getParameter("scheduleDate").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	} 

	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	// 디버깅 코드
	System.out.println(scheduleNo + "deleteScheduleForm param scheduleNo");
	System.out.println(scheduleDate + "deleteScheduleForm param scheduleDate");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteScheduleForm.jsp</title>
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
    color:#FFFFFF;}
    .right{text-align:right;}
    .none{border-style: none;}
</style>
</head>
<body>
	<div class="container p-3"><!-- 메인메뉴 -->
		<a href="./home.jsp" class="btn">홈</a>
		<a href="./noticeList.jsp" class="btn">공지</a>
		<a href="./scheduleList.jsp" class="btn">일정</a>
	</div>
	<div class="container p-3">
		<!-- deleteScheduleAction.jsp 페이지에서 유효성 검사시 msg!=null 때 msg를 출력 -->
		<%
			String msg = request.getParameter("msg");
			if(msg!= null){
		%>
				<%=msg%>
		<%		
			}
		%>
	</div>
	<form action="./deleteScheduleAction.jsp?scheduleNo=<%=scheduleNo%>&scheduleDate=<%=scheduleDate%>" method="post">
		<div class="container p-3">
		<h3>일정 삭제</h3>
		<table class="table table-sm">
			<tr>
				<td>번호</td>
				<td>
					<input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly" class="none">
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
					<input type="password" name="schedulePw">
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