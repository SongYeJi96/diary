<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.URLEncoder"%>
<%

	// request 인코딩
	request.setCharacterEncoding("utf-8");

	/* validation(요청 파라미터간 유효성 검사)
	* 요청값이 null이 들어왔을 때 insertNoticeForm.jsp에 보여주는 메세지 분기
	* 값이 null, "" 이면 insertNoticeForm.jsp 페이지로 리턴
	*/
	String msg =null;
	if(request.getParameter("noticeTitle")==null
		|| request.getParameter("noticeTitle").equals("")){
		msg ="제목이 입력되지 않았습니다";
	} else if(request.getParameter("noticeContent")==null
	|| request.getParameter("noticeContent").equals("")){
		msg ="공지가 입력되지 않았습니다";
	} else if(request.getParameter("noticeWriter")==null
	|| request.getParameter("noticeWriter").equals("")){
		msg ="작성인이 입력되지 않았습니다";
	} else if(request.getParameter("noticePw")==null
	|| request.getParameter("noticePw").equals("")){
		msg ="비밀번호가 입력되지 않았습니다";
		 
	}
	 if(msg != null) {
    	String rmsg =  URLEncoder.encode(msg,"utf-8");
    	response.sendRedirect("./insertNoticeForm.jsp?msg="+rmsg);
		return;
	}
	
	// request.getParameter 받은 값 변수에 저장
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	// 디버깅 코드(변수에 값이 받아졌는지 확인)
	System.out.println(noticeTitle+"<--insertNoticeAction param noticeTitle");
	System.out.println(noticeContent+"<--insertNoticeAction param noticeContent");
	System.out.println(noticeWriter+"<--insertNoticeAction param noticeWriter");
	System.out.println(noticePw+"<--insertNoticeAction param noticePw");
	
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("insertNoticeAction.jsp DB 연결성공"+conn);
	// insert sql문 작성
	String sql = "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql); // ? 4개(1~4)
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	// 디버깅 코드(stmt의 저장된 쿼리 확인)
	System.out.println(stmt + "<--insertNoticeAction.jsp stmt");
	
	int row = stmt.executeUpdate(); //디버깅 코드. 
	// conn.commit(); // conn.setAutoCommit(true); 디폴트 값이 true라 자동 commit -> commit 생략 가능
	// 디버깅 코드(row 값 확인)
	System.out.print(row+"<--insertNoticeAction.jsp row");
	
	/* row 1이면 1행 입력 성공, 0이면 입력된 행이 없음
	* 입력된 행이 없으면 insertNoticeForm.jsp 페이지로 이동
	* 행이 입력되면 noticeList.jsp 페이지로 이동
	*/
	if(row == 0){
		response.sendRedirect("./insertNoticeForm.jsp");
	}else if(row == 1){ 
		response.sendRedirect("./noticeList.jsp");
	}else {
		System.out.println("error row값 : "+row);
	}
%>