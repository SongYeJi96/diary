<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import="vo.Schedule" %>
<%
	// 요청값 변수 초기화
	String y = null;
	int m = 0;
	int d = 0;
	String scheduleDate = null;
	
	// 요청값 유효성 검사
	if(request.getParameter("scheduleDate") !=null){
		scheduleDate = request.getParameter("scheduleDate");
		System.out.println(scheduleDate + "<--scheduleListByDate param scheduleDate");
		
		// substring으로 필요한 문자열만 자른 후 저장
		y = scheduleDate.substring(0,4);
		m = Integer.parseInt(scheduleDate.substring(5,7));
		d =  Integer.parseInt(scheduleDate.substring(8));
	} else{
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
		
		y = request.getParameter("y");
		m = Integer.parseInt(request.getParameter("m")) +1; // 자바API에서 월은 0-11, 마리아DB에서 월은 1-12월
		d = Integer.parseInt(request.getParameter("d"));
	}
	
	System.out.println(y + "<-- scheduleListByDate param y");
	System.out.println(m + "<-- scheduleListByDate param m");
	System.out.println(d + "<-- scheduleListByDate param d");
	
	//1~9 월m, 일d 앞에 0을 붙이는 분기 +""은 문자열로 바꿔주기 위해 한다.
		String strM = m+"";
		if(m<10){
			strM = "0"+strM;
		}
		String strD = d+"";
		if(d<10){
			strD = "0"+strD;
		}
	// 요청값 결합
	String [] cashbookDateArr = {y, strM, strD};
	scheduleDate = String.join("-", cashbookDateArr);
	
	// 일별 스케쥴 리스트
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 쿼리 작성
	String sql = "select schedule_no, schedule_date, schedule_time, schedule_color, schedule_memo, createdate, updatedate from schedule where schedule_date= ? order by schedule_time desc ";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate);
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
<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
	<div class="main-container">
		<div class="cell-header">
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="cell-content">
			<!-- insertScheduleAction.jsp 페이지에서 들어온 msg의 값이 null이 아니면 msg 출력 --> 
			<div class="container">
				<%	
					String msg = request.getParameter("msg");
					if(msg!= null){
				%>
						<%=msg%>
				<%		
					}
				%>
			</div>
			<!-- 일정입력 폼 -->
			<form action="insertScheduleAction.jsp" method="post">
				<h3 class="container p-3">일정 등록</h3>
				<div class="container p-3">
					<table class="table">
						<tr>
							<th>날짜</th>
							<td>
								<input type="hidden" name="scheduleDate" value="<%=scheduleDate%>">
								<%=scheduleDate%>
							</td>
						</tr>
						<tr>
							<th>시간</th>
							<td>
								<input type="time" name="scheduleTime" class="form-control w-25">
							</td>
						</tr>
						<tr>
							<th>색상</th>
							<td>
								<input type="color" name="scheduleColor" value="#000000" class="form-control w-25">
							</td>
						</tr>
						<tr>
							<th>일정</th>
							<td>
								<textarea rows="10" name="scheduleMemo" class="form-control"></textarea>
							</td>
						</tr>
						<tr>
							<th>비밀번호</th>
							<td>
								<input type="password" name="schedulePw" class="form-control w-25">
							</td>
						</tr>
					</table>
				</div>
				<div class="container text-right">
					<button type="submit" class="btn">등록</button>
				</div>
			</form>
			<!-- 금일 일정 목록 -->
			<h3 class="container p-3"><%=y%>년 <%=strM%>월 <%=strD%>일 일정 목록</h3>
			<div class="container p-3">
				<table class="table">
					<thead>
					<tr>
						<th>시간</th>
						<th>일정</th>
						<th>작성일</th>
						<th>수정일</th>
					</tr>
					</thead>
					<tbody>
					<%
						for(Schedule s : scheduleList ){
					%>
						<tr onclick="location.href='<%=request.getContextPath()%>/scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>'">
							<td><%=s.scheduleTime.substring(0,5)%></td>
							<td class="tdMemo"><%=s.scheduleMemo%></td>
							<td><%=s.createdate.substring(0, 10)%></td>
							<td><%=s.updatedate.substring(0, 10)%></td>
						</tr>
					<%
						}
					%>
					</tbody>
				</table>
			</div>
		</div>
		<div class="cell-footer">
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>