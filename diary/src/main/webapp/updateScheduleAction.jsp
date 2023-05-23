<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder"%>
<%
	// 한글이 깨질 수 있으므로 request 인코딩
	request.setCharacterEncoding("utf-8");

	// 요청값이 넘어왔는지 확인
	System.out.println(request.getParameter("scheduleNo")+"<--updateScheduleAction scneduleNo");
	System.out.println(request.getParameter("scheduleDate")+"<--updateScheduleAction scneduleDate");
	System.out.println(request.getParameter("scheduleTime")+"<--updateScheduleAction scneduleTime");
	System.out.println(request.getParameter("scheduleMemo")+"<--updateScheduleAction scneduleMemo");
	System.out.println(request.getParameter("scheduleColor")+"<--updateScheduleAction scneduleColor");
	System.out.println(request.getParameter("schedulePw")+"<--updateScheduleAction scnedulePw");
	
	/* 요청값 유효성 검사
	* scheduleNo의 값이 null,"" 이면 scheduleList.jsp 페이지로 리턴
	*/
	if(request.getParameter("scheduleNo")==null
		|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	/* 요청값 유효성 검사
	* 요청값이 null이 들어왔을 때 updateScheduleForm.jsp에 보여주는 메세지 분기
	* 값이 null,"" 이면 updateScheduleForm.jsp 페이지로 리턴
	* 페이지 이동시 scheduleNo, msg 전달
	*/
	String msg = null;
	if(request.getParameter("scheduleDate")==null
		|| request.getParameter("scheduleDate").equals("")){
			msg ="날짜가 입력되지 않았습니다";
	} else if(request.getParameter("scheduleTime")==null
		|| request.getParameter("scheduleTime").equals("")){
			msg ="시간이 입력되지 않았습니다";
		} else if(request.getParameter("scheduleMemo")==null
		|| request.getParameter("scheduleMemo").equals("")){
			msg ="일정이 입력되지 않았습니다";
		} else if(request.getParameter("scheduleColor")==null
		|| request.getParameter("scheduleColor").equals("")){
			msg ="색이 선택되지 않았습니다";
		} else if(request.getParameter("schedulePw")==null
		|| request.getParameter("schedulePw").equals("")){
			msg ="비밀번호가 입력되지 않았습니다";
	}
	if(msg != null) {
    	String rmsg =  URLEncoder.encode(msg,"utf-8");
    	response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="+request.getParameter("scheduleNo")+"&msg="+rmsg);
		return;
	}	
		
	// 요청값을 변수에 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String scheduleColor = request.getParameter("scheduleColor");
	String schedulePw = request.getParameter("schedulePw");
	// 디버깅 코드
	System.out.println(scheduleNo +"updateScheduleAction param scheduleNo");
	System.out.println(scheduleDate +"updateScheduleAction param scheduleDate");
	System.out.println(scheduleTime +"updateScheduleAction param scheduleTime");
	System.out.println(scheduleMemo +"updateScheduleAction param scheduleMemo");
	System.out.println(scheduleColor +"updateScheduleAction param scheduleColor");
	System.out.println(schedulePw +"updateScheduleAction param schedulePw");
	
	// substring으로 필요한 문자열만 자른 후 저장
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1; //byDate.jsp 에서 month에 +1로 넘어와서 -1을 해준다(??)
	String d = scheduleDate.substring(8);
	// 디버깅 코드(필요한 문자열이 변수에 저장 되었는지 확인)
	System.out.println(y + "<-- insertScheduleAction y");
	System.out.println(m + "<-- insertScheduleAction m");
	System.out.println(d + "<-- insertScheduleAction d");
		
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("updateScheduleAction DB접속성공"+conn);
	
	// 쿼리 작성 (UPDATE [테이블] SET [열] = '변경할값' WHERE [조건])
	String sql = "update schedule set schedule_date = ?, schedule_time = ?, schedule_memo = ?, schedule_color = ?,  updatedate = now() where schedule_no = ? and schedule_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setInt(5, scheduleNo);
	stmt.setString(6, schedulePw);
	// 디버깅 코드(stmt의 저장된 쿼리 확인)
	System.out.println(stmt + "<--updateScheduleAction stmt");
	
	int row = stmt.executeUpdate();
	// 디버깅 코드(수정 성공한 행의 수 출력)
	System.out.println(row + "<--row updateScheduleAction 수정 성공한 행의 수");
		
	/* redirection
	* stmt.executeUpdate에 성공, 실패에 따른 페이지 이동
	* row == 1: scheduleListByDate.jsp 페이지 이동. 이동 시 y, m, d 값 전달 
	* row == 0: updateScheduleForm.jsp 페이지 이동. 이동시 scheduleNo, msg 값 전달
	*/
	if(row == 0){
		String incorrectPw = URLEncoder.encode("비밀번호가 맞지않습니다","utf-8");
		response.sendRedirect("./updateScheduleForm.jsp?noticeNo="+scheduleNo+"&msg="+incorrectPw);
	}else if(row == 1){
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	}else {
		System.out.println("error row값 : "+row);
	}	
%>
