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
<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
	<div class="main-container">
		<div class="cell-header">
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="cell-content">
			<!-- updateScheduleAction.jsp 페이지에서 들어온 msg의 값이 null이 아니면 msg 출력 -->
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
			<!-- 일정수정 폼 -->
			<form action="updateScheduleAction.jsp?scheduleNo=<%=scheduleNo%>" method="post">
				<h3 class="container p-3">일정 수정</h3>
				<div class="container p-3">
					<table class="table">
						<tr>
							<th>날짜</th>
							<td>
								<input type="date" name="scheduleDate" value="<%=schedule.scheduleDate%>" class="form-control w-25">
							</td>
						</tr>
						<tr>
							<th>시간</th>
							<td>
								<input type="time" name="scheduleTime" value="<%=schedule.scheduleTime%>" class="form-control w-25">
							</td>
						</tr>
						<tr>
							<th>색상</th>
							<td>
								<input type="color" name="scheduleColor" value="<%=schedule.scheduleColor%>" class="form-control w-25">
							</td>
						</tr>
						<tr>
							<th>메모</th>
							<td>
								<textarea rows="10" name="scheduleMemo" class="form-control"><%=schedule.scheduleMemo%></textarea>
							</td>
						</tr>
						<tr>
							<th>비밀번호</th>
							<td>
								<input type="password" name="schedulePw" class="form-control">
							</td>
						</tr>
					</table>
				</div>
				<div class="container text-right">
					<button type="submit" class="btn">수정</button>
					<button type="button" onclick="location.href='./scheduleOne.jsp?scheduleNo=<%=scheduleNo%>'" class="btn">취소</button>
				</div>
			</form>
		</div>
		<div class="cell-footer">
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>