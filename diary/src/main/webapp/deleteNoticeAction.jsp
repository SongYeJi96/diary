<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@page import="java.net.URLEncoder"%>
<%
	// request 인코딩
	request.setCharacterEncoding("utf-8");
	
	/* 요청값 유효성 검사(요청한 값에 null, ""이 있는지 확인)
	* noticeNo의 null, ""값이 들어오면 noticeList.jsp 페이지로 리턴
	* noticePw의 null, ""값이 들어오면 deleteNoticeForm.jsp 페이지로 리턴
	* 페이지 이동시 noticeNo, msg 전달
	*/
	if(request.getParameter("noticeNo") == null
		|| request.getParameter("noticeNo").equals("")){
		response.sendRedirect("./noticeList.jsp");
		return;
	} else if(request.getParameter("noticePw") == null
		|| request.getParameter("noticePw").equals("")){
		// url에 보낼 메세지 인코딩 하여 변수에 저장
		String msg = URLEncoder.encode("비밀번호 값이 입력되지 않았습니다","utf-8");
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+request.getParameter("noticeNo")+"&msg="+msg);
		return;
	}
	
	// request.getParameter로 받은 값을 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	// 디버깅 코드(request.getParameter로 값을 받아와 저장이 되었는지 확인)
	System.out.println(noticeNo+"<--deleteNoticeAction param noticeNo");
	System.out.println(noticePw+"<--deleteNoticeAction param noticePw");
	
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("deleteNoticeAction.jsp DB 드라이버 연결성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("deleteNoticeAction DB접속성공"+conn);
	// 쿼리 작성
	String sql = "delete from notice where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql); // ? 2개(1~2)
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	// 디버깅 코드(stmt의 저장된 쿼리 확인)
	System.out.println(stmt + "<--deleteNoticeAction.jsp stmt");
	
	/* 업데이트한 행의 값을 변수에 저장
	* stmt.executeUpdate()시 비빌번호가 틀려서 삭제된 행이 없으면 deleteNoticeForm.jsp 페이지로 이동
	* 페이지 이동시 noticeNo, msg 전달
	* 삭제가 되면 noticeList.jsp 페이지로 이동
	*/
	int row = stmt.executeUpdate();
	System.out.println(row + "<-- deleteNoticeAction.jsp");
	if(row == 0){
		String incorrectPw = URLEncoder.encode("비밀번호가 맞지않습니다","utf-8");
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo+"&msg="+incorrectPw);
	}else if(row == 1){
		response.sendRedirect("./noticeList.jsp");
	}else {
		System.out.println("error row값 : "+row);
	}
%>