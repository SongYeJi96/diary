<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.Schedule" %>
<%
	//한글이 깨질 수 있으므로 request 인코딩
	request.setCharacterEncoding("utf-8");

	//요청값 유효성 검사
	// scheduleNo의 값이 null,"" 이면 home.jsp 페이지로 리턴
	if(request.getParameter("scheduleNo")==null
		|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./home.jsp");
		return;
	}
	
	// 요청값을 변수에 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	// 디버깅 코드
		System.out.println(scheduleNo +"scheduleOne param scheduleNo");
	
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 디버깅 코드(DB 접속 확인)
	System.out.println("scheduleOne.jspDB접속성공"+conn);
	// 쿼리 작성
	String sql = "select schedule_no, schedule_memo, schedule_date, schedule_time, schedule_color, createdate, updatedate from schedule where schedule_no = ?"; 
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo); // stmt의 첫번째 ? 값을 변경
	System.out.println(stmt + "<--scheduleOne.jsp stmt");
	ResultSet rs = stmt.executeQuery();
	
	// 1행 출력, vo.Schedule 객체 만들어 값 저장
	Schedule schedule = null;
	if(rs.next()){
		schedule = new Schedule();
		schedule.scheduleNo = rs.getInt("schedule_no");
		schedule.scheduleDate = rs.getString("schedule_date");
		schedule.scheduleTime = rs.getString("schedule_time");
		schedule.scheduleMemo = rs.getString("schedule_memo");
		schedule.createdate = rs.getString("createdate");
		schedule.updatedate = rs.getString("updatedate");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleOne.jsp</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a {
	text-decoration: none;
	color:#000000;}
	a.btn{
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
	<h3>일정 상세</h3>
		<table class="table table-sm">
			<tr>
				<td>번호</td>
				<td><%=scheduleNo%></td>
			</tr>
			<tr>
				<td>날짜</td>
				<td><%=schedule.scheduleDate%></td>
			</tr>
			<tr>
				<td>시간</td>
				<td><%=schedule.scheduleTime%></td>
			</tr>
			<tr>
				<td>일정</td>
				<td><%=schedule.scheduleMemo%></td>
			</tr>
			<tr>
				<td>등록일</td>
				<td><%=schedule.createdate.substring(0,10)%></td>
			</tr>
			<tr>
				<td>수정일</td>
				<td><%=schedule.updatedate.substring(0,10)%></td>
			</tr>
		</table>
	</div>
	<div class="container right">
		<a href="./updateScheduleForm.jsp?scheduleNo=<%=scheduleNo%>" class="btn">수정</a>
		<a href="./deleteScheduleForm.jsp?scheduleNo=<%=scheduleNo%>&scheduleDate=<%=schedule.scheduleDate%>" class="btn">삭제</a>
	</div>
</body>
</html>