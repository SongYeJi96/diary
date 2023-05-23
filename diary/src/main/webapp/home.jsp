<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@page import="vo.*"%>
<%
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("home.jsp 접속성공"+conn);
	
	// 최근공지 5개 출력
	String sql = "select notice_no noticeNo, notice_title noticeTitle, createdate"
					+" "+"from notice order by createdate desc limit 0, 5";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + "<--home.jsp stmt");
	ResultSet rs = stmt.executeQuery();
		
	// vo.Notice ArrayList 
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
		
	// 오늘 일정 출력
	String sql2="select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo,1,10) memo"
					+" "+"from schedule where schedule_date = curdate() order by schedule_time asc";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println(stmt2 + "<--home.jsp stmt2");
	ResultSet rs2 = stmt2.executeQuery();
	
	// vo.Schedule ArrayList
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs2.next()){
		Schedule s = new Schedule();		
		s.scheduleNo = rs2.getInt("scheduleNo");
		s.scheduleDate = rs2.getString("scheduleDate");
		s.scheduleTime = rs2.getString("scheduleTime");
		s.scheduleMemo = rs2.getString("memo");
		scheduleList.add(s);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>home.jsp</title>
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
    thead{background-color: #E7E7E7;}
    tbody{cursor: pointer;}
    .tdtitle:hover{
    color:#0100FF;
    }
</style>
</head>
<body>
	<div class="container p-3"><!-- 메인메뉴 -->
		<a href="./home.jsp" class="btn">홈</a>
		<a href="./noticeList.jsp" class="btn">공지</a>
		<a href="./scheduleList.jsp" class="btn">일정</a>
	</div>
		
	<div class="container p-3">
	<h3>공지사항</h3>
		<table class="table table-sm">
			<thead>
			<tr>
				<th>제목</th>
				<th>등록일</th>
			</tr>
			</thead>
			<%
				for(Notice n : noticeList){
			%>
				<tbody>
					<tr onclick="location.href='./noticeOne.jsp?noticeNo=<%=n.noticeNo%>'">
						<td class="tdtitle"><%=n.noticeTitle%></td>
						<td><%=n.createdate.substring(0,10)%></td>
					</tr>
				</tbody>
			<%		
				}
			%>
		</table>
	</div>
	
	<div class="container p-3">
	<h3>오늘 일정</h3>
		<table class="table table-sm">
			<thead>
				<tr>
					<th>날짜</th>
					<th>시간</th>
					<th>일정</th>
				</tr>
			</thead>
			<%
				for(Schedule s : scheduleList ){		
			%>
				<tbody>
					<tr onclick="location.href='./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>'">
						<td>
							<%=s.scheduleDate%>
						</td>
						<td>
							<%=s.scheduleTime.substring(0, 5)%>
						</td>
						<td>
		                  	<%=s.scheduleMemo%>
						</td>
					</tr>
				</tbody>
			<%		
				}
			%>
		</table>
	</div >
	<div class="container p-3">
	<h3>다이어리 프로젝트(첫 수업 시작일로부터 3주 진행)</h3>
	<p>개발환경 : Eclipse(2022-12), JDK(17.0.6), Mariadb, tomcat(10), HeidSQL</p>
	<p>프로젝트 내용</p>
	<p>1. 데이터베이스 만들기</p>
	<p>2. Eclipse에 DB 연결하여 select, insert, update, delete가 가능한 Form.jsp, Action.jsp 페이지 작성</p>
	<p>3. Calendar API 사용하여 달력 제작</p>
	</div>
</body>
</html>