<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.Schedule" %>
<%
	/* 요청값 유효성 검사
	* null, ""값이 들어오면 scheduleListByDate.jsp 페이지로 리턴
	*/
	if(request.getParameter("scheduleNo")==null
		|| request.getParameter("scheduleNo").equals("")){
		
		response.sendRedirect("scheduleListByDate.jsp");
		return;
	}
	
	//request.getParameter로 받은 값을 변수에 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	// 디버깅 코드(parameter로 값을 받았는지 확인)
	System.out.println(scheduleNo + "<--updateScheduleForm param scheduleNo");
		
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");	
	// mariadb에 로그인 후 접속정보 반환하여 저장(데이터베이스:diary)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 디버깅 코드(DB 접속 확인)
	System.out.println("updateScheduleForm DB접속성공"+conn);
		
	// 쿼리 작성(SELECT [열] FROM [테이블] WHERE = [조건])
	String sql = "select schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor from schedule where schedule_no = ?";
	// conn안에 sql문을 쿼리로 만들어 PreparedStatement 변수 stmt에 저장
	PreparedStatement stmt = conn.prepareStatement(sql); // ?(1)
	stmt.setInt(1, scheduleNo);
	// 디버깅 코드(stmt의 저장된 쿼리 확인)
	System.out.println(stmt + "<--udateStoreForm stmt");
	// stmt의 저장된 결과를 반환하여 ResultSet 변수에 저장
	ResultSet rs = stmt.executeQuery();
	
	// 1행을 출력, vo.Schedule 객체 생성하여 값 저장 
	Schedule schedule = null; // 모델데이터
	if(rs.next()){
		schedule = new Schedule();
		schedule.scheduleDate = rs.getString("scheduleDate");
		schedule.scheduleTime = rs.getString("scheduleTime");
		schedule.scheduleColor = rs.getString("scheduleColor");
		schedule.scheduleMemo = rs.getString("scheduleMemo");
	}
%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateScheduleForm.jsp</title>
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
    width:100px;
    line-height:20px;
    text-align:center;
    background-color:#333333;
    color:#FFFFFF;}
    .right{text-align:right;}
</style>
</head>
<body>
	<div class="container p-3"><!-- 메인메뉴 -->
		<a href="./home.jsp" class="btn">홈</a>
		<a href="./noticeList.jsp" class="btn">공지</a>
		<a href="./scheduleList.jsp" class="btn">일정</a>
	</div>
	<div class="container p-3">
	<!-- updateScheduleAction.jsp 페이지에서 들어온 msg의 값이 null이 아니면 msg 출력 -->
		<%
			String msg = request.getParameter("msg");
			if(msg!= null){
		%>
				<%=msg%>
		<%		
			}
		%>
	</div>
		<form action="updateScheduleAction.jsp?scheduleNo=<%=scheduleNo%>" method="post">
			<div class="container p-3">
			<h3>일정 수정</h3>
				<table class="table table-sm">
				<tr>
					<th>날짜</th>
					<td>
						<input type="date" name="scheduleDate" value="<%=schedule.scheduleDate%>">
					</td>
				</tr>
				<tr>
					<th>시간</th>
					<td>
						<input type="time" name="scheduleTime" value="<%=schedule.scheduleTime%>">
					</td>
				</tr>
				<tr>
					<th>색상</th>
					<td>
						<input type="color" name="scheduleColor" value="<%=schedule.scheduleColor%>">
					</td>
				</tr>
				<tr>
					<th>메모</th>
					<td>
						<textarea rows="8" cols="50" name="scheduleMemo"><%=schedule.scheduleMemo%>
						</textarea>
					</td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="schedulePw">
					</td>
				</tr>
			</table>
		</div>
		<div class="container right">
			<button type="submit" class="btn">수정</button>
		</div>
	</form>
</body>
</html>