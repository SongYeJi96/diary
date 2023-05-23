<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import="vo.Schedule" %>
<%
	// 요청값 유효성 검사
	// y, m, d 값이 null or "" -> redirection scheduleList.jsp
	if(request.getParameter("y")==null
		|| request.getParameter("m")==null
		|| request.getParameter("d")==null
		|| request.getParameter("y").equals("")
		|| request.getParameter("m").equals("")
		|| request.getParameter("d").equals("")){
		
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m")) +1; // 자바API에서 월은 0-11, 마리아DB에서 월은 1-12월
	int d = Integer.parseInt(request.getParameter("d"));
	
	System.out.println(y + "scheduleListByDate param y");
	System.out.println(m + "scheduleListByDate param m");
	System.out.println(d + "scheduleListByDate param d");
	
	// 1~9 월m, 일d 앞에 0을 붙이는 분기 +""은 문자열로 바꿔주기 위해 한다.
	String strM = m+"";
	if(m<10){
		strM = "0"+strM;
	}
	String strD = d+"";
	if(d<10){
		strD = "0"+strD;
	}
	
	// 일별 스케쥴 리스트
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 쿼리 작성
	String sql = "select schedule_no, schedule_date, schedule_time, schedule_color, schedule_memo, createdate, updatedate from schedule where schedule_date= ? order by schedule_time desc ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, y+"-"+strM+"-"+strD);
	System.out.println(stmt + "<-- scheduleListBydate.jsp");
	ResultSet rs = stmt.executeQuery();
	

	// vo.Schedule ArrayList
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("schedule_no");
		s.scheduleDate = rs.getString("schedule_date");
		s.scheduleTime = rs.getString("schedule_time");
		s.scheduleColor = rs.getString("schedule_color");
		s.scheduleMemo = rs.getString("schedule_memo");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleListByDate.jsp</title>
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
    button.btn{
    display:inline-block;
    width:100px;
    line-height:20px;
    text-align:center;
    background-color:#333333;
    color:#FFFFFF;}
    .right{text-align:right;}
    .none {border-style:none;}
    thead{background-color: #E7E7E7;}
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
			// insertScheduleAction.jsp 페이지에서 들어온 msg의 값이 null이 아니면 msg 출력
			String msg = request.getParameter("msg");
			if(msg!= null){
		%>
				<%=msg%>
		<%		
			}
		%>
	</div>
	<form action="insertScheduleAction.jsp" method="post">
		<div class="container p-3">
		<h3>일정 입력</h3>
		<table class="table table-sm">
			<tr>
				<th>날짜</th>
				<td>
					<input type="date" name="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly" class="none">
				</td>
			</tr>
			<tr>
				<th>시간</th>
				<td>
					<input type="time" name="scheduleTime">
				</td>
			</tr>
			<tr>
				<th>색상</th>
				<td>
					<input type="color" name="scheduleColor" value="#000000">
				</td>
			</tr>
			<tr>
				<th>일정</th>
				<td>
					<textarea rows="8" cols="50" name="scheduleMemo"></textarea>
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
			<button type="submit" class="btn">입력</button>
		</div>
	</form>
	
	<div class="container p-3">
	<h3><%=y%>년 <%=strM%>월 <%=strD%>일 일정 목록</h3>
		<table class="table table-sm">
			<thead>
			<tr>
				<th>시간</th>
				<th>일정</th>
				<th>작성일</th>
				<th>수정일</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
			</thead>
			<%
				for(Schedule s : scheduleList ){
			%>
				<tr>
					<td><%=s.scheduleTime.substring(0,6)%></td>
					<td><%=s.scheduleMemo%></td>
					<td><%=s.createdate.substring(0, 10)%></td>
					<td><%=s.updatedate.substring(0, 10)%></td>
					<td><a href="updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">수정</a></td>
					<td><a href="deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>&scheduleDate=<%=s.scheduleDate%>">삭제</a></td>
				</tr>
			<%
				}
			
			%>
		</table>
	</div>
</body>
</html>