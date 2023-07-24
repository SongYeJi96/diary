<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import="java.net.URLEncoder"%>
<%

	// insert 성공, 실패 상관없이 scheduleListByDate.jsp 페이지로 이동
	// request 인코딩
	request.setCharacterEncoding("utf-8");
	
	// 요청값 유효성 검사. scheduleDate는 null 값이 들어오면 코드 진행중 오류가 발생하여 ./scheduleList.jsp 페이지로 이동
	if(request.getParameter("scheduleDate") == null
		|| request.getParameter("scheduleDate").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	// request.getParameter로 받아온 값 변수에 저장
	String scheduleDate = request.getParameter("scheduleDate");
	// 디버깅 코드(변수에 값이 받아졌는지 확인)
	System.out.println(scheduleDate + " <-- insertScheduleAction param scheduleDate");
	
	// substring으로 필요한 문자열만 자른 후 저장
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1; //byDate.jsp 에서 month에 +1로 넘어와서 -1을 해준다(??)
	String d = scheduleDate.substring(8);
	// 디버깅 코드(필요한 문자열이 변수에 저장 되었는지 확인)
	System.out.println(y + "<-- insertScheduleAction y");
	System.out.println(m + "<-- insertScheduleAction m");
	System.out.println(d + "<-- insertScheduleAction d");
	
	/* 요청값 유효성 검사
	* 요청값이 null이 들어왔을 때 scheduleListByDate.jsp에 보여주는 메세지 분기
	* 값이 null, "" 이면 scheduleListByDate.jsp 페이지로 리턴
	* 페이지 이동시 y, m, d, msg 전달
	*/
	String msg = null;
	 if(request.getParameter("scheduleTime")==null
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
    	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d+"&msg="+rmsg);
		return;
	}
	// request.getParameter로 받아온 값 변수에 저장
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	// 디버깅 코드(변수에 값이 받아졌는지 확인)
	System.out.println(scheduleTime + " <-- insertScheduleAction param scheduleTime");
	System.out.println(scheduleColor + " <-- insertScheduleAction param scheduleColor");
	System.out.println(scheduleMemo + " <-- insertScheduleAction param scheduleMemo");
	System.out.println(schedulePw + " <-- insertScheduleAction param schedulePw");
	
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("insertScheduleAction.jsp DB 접속성공"+conn);
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_memo, schedule_color, createdate, updatedate, schedule_pw) values(?,?,?,?,now(),now(),?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setString(5, schedulePw);
	// 디버깅 코드(stmt의 저장된 쿼리 확인)
	System.out.println(stmt + "<--insertScheduleAction stmt");
	
	/* row 1이면 1행 입력 성공, 0이면 입력된 행이 없음
	* 입력된 행이 없으면 scheduleListByDate.jsp 페이지로 이동. 페이지 이동시 y, m, d, msg 전달
	* 행이 입력되면 scheduleListByDate.jsp 페이지로 이동. 페이지 이동시 y, m, d, 전달
	*/
	int row = stmt.executeUpdate();
	System.out.println(row +"insertScheduleAction.jsp row");
	if(row == 0) {
		String incorrectPw = URLEncoder.encode("비밀번호가 맞지않습니다","utf-8");
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d+"&msg="+incorrectPw);
	} else if(row == 1){
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	} else{
		System.out.println("insertScheduleAction 비정상 입력 row : "+ row);
	}
%>
