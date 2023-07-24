<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import="java.net.URLEncoder"%>
<%
	// request 인코딩
	request.setCharacterEncoding("utf-8");

	/* 요청값 유효성 검사(요청한 값에 null, ""이 있는지 확인)
	* scheduleNo, Date에 null, ""값이 들어오면 scheduleList.jsp 페이지로 리턴
	* schedulePw에 null, ""값이 들어오면 deleteScheduleForm.jsp 페이지로 리턴
	* 페이지 이동시 scheduleNo, msg 전달
	*/
	if(request.getParameter("scheduleNo") == null
		|| request.getParameter("scheduleDate")==null
		|| request.getParameter("scheduleNo").equals("")
		|| request.getParameter("scheduleDate").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;	
	} else if(request.getParameter("schedulePw") == null
	  || request.getParameter("schedulePw").equals("") ){
		String msg = URLEncoder.encode("비밀번호 값이 입력되지 않았습니다","utf-8");
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="+request.getParameter("scheduleNo")+
		"&scheduleDate="+request.getParameter("scheduleDate")+"&msg="+msg);
		return;
	}

	//request.getParameter로 받은 값을 변수에 저장
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	String scheduleDate = request.getParameter("scheduleDate");
	
	// 디버깅 코드(request.getParameter로 값을 받아와 저장이 되었는지 확인)
	System.out.println(scheduleNo+"<--deleteScheduleAction param scheduleNo");
	System.out.println(schedulePw+"<--deleteScheduleAction param schedulePw");
	System.out.println(scheduleDate+"<--deleteScheduleAction param scheduleDate");
	
	/* scheduleDate substring으로 필요한 문자열만 자른 후 저장
	* y = 연, m = 월, d = 일
	*/
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1;
	String d = scheduleDate.substring(8);
	// 디버깅 코드(필요한 문자열이 변수에 저장 되었는지 확인)
	System.out.println(y + "<-- deleteScheduleAction y");
	System.out.println(m + "<-- deleteScheduleAction m");
	System.out.println(d + "<-- deleteScheduleAction d");
	
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("deleteScheduleAction DB 드라이버 연결성공");//
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("deleteScheduleAction 접속성공"+conn);
	// 쿼리 작성
	String sql = "delete from schedule where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql); // ? 2개(1~2)	
	stmt.setInt(1, scheduleNo);
	stmt.setString(2, schedulePw);
	// 디버깅 코드(stmt의 저장된 쿼리 확인)
	System.out.println(stmt + "<--deleteScheduleAction.jsp stmt");
	
	/* stmt.executeUpdate후 변수에 값 저장
	* 비밀번호가 틀려서 삭제된 행이 없으면 deleteScheduleForm.jsp 페이지로 이동
	* 페이지 이동시 scheduleNo, scheduleDate, msg 전달
	* 행이 삭제 되면 scheduleListByDate.jsp 페이지로 이동
	* 페이지 이동시 y, m, d 전달
	*/
	int row = stmt.executeUpdate();
	System.out.println(row + "<-- row deleteScheduleAction.jsp");
	if(row == 0){
		String msg = URLEncoder.encode("비밀번호 값이 잘못 입력되었습니다","utf-8");
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="+scheduleNo+"&scheduleDate="+scheduleDate+"&msg="+msg);
	}else if(row == 1){ 
		response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	}else {
		System.out.println("error row값 : "+row);
	}
%>