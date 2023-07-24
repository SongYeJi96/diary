<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.URLEncoder"%>
<%
	// request 인코딩 설정
	request.setCharacterEncoding("utf-8");

	// 4개의 값이 넘어 왔는지 확인
	System.out.println(request.getParameter("noticeNo") + "<--updateNoticAction noticeNo");
	System.out.println(request.getParameter("noticeTitle") + "<--updateNoticAction noticeTitle");
	System.out.println(request.getParameter("noticeCountent") + "<--updateNoticAction noticeContent");
	System.out.println(request.getParameter("noticePw") + "<--updateNoticAction noticePw");
	
	/* 요청값(noticeNo) 유효성 검사(요청한 값에 null, ""이 있는지 확인)
	 * null, ""값이 들어오면 noticeList.jsp 페이지로 리턴*/
	if(request.getParameter("noticeNo")==null
		|| request.getParameter("noticeNo").equals("")){
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	/* 요청값 유효성 검사(요청한 값에 null, ""이 있는지 확인)
	* 요청값이 null이 들어왔을 때 updateNoticeForm.jsp에 보여주는 메세지 분기
	* null, ""값이 들어오면 updateNoticeForm.jsp 페이지로 리턴
	* noticeNo 값을 같이 보내야 updateNoticeForm.jsp로 간다. 
	* 추가 하지 않으면 null,"" 값이 들어왔을 때 noticeList.jsp로 이동한다.
	*/
	String msg =null;
	if(request.getParameter("noticePw")==null
	|| request.getParameter("noticePw").equals("")){
		msg ="비밀번호가 입력되지 않았습니다";
	} else if(request.getParameter("noticeTitle")==null
	|| request.getParameter("noticeTitle").equals("")){
		msg ="제목이 입력되지 않았습니다";
	} else if(request.getParameter("noticeContent")==null
	|| request.getParameter("noticeContent").equals("")){
		msg ="공지내용이 입력되지 않았습니다";
	}
	/* msg가 null이 아니면 updatNoticeForm.jsp에 noticeNo값, msg를 보낸다.
    * msg가 url 주소에서 한글이면 인코딩이 안되서 URLEncoder.encode 메소드를 사용하여 인코딩을 한다.
    * url에 입력할 변수 rmsg를 만들어 msg를 utf-8로 인코딩 하여 저장한다. 변수 rmsg는 if문 안에 작성. 밖에 작성하면 오류발생.
    */
    if(msg != null) {
    	String rmsg =  URLEncoder.encode(msg,"utf-8");
    	response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+request.getParameter("noticeNo")+"&msg="+rmsg);
		return;
	}
	
	//request.getParameter로 받은 값을 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	
	// 디버깅 코드(request.getParameter로 값을 받아와 저장이 되었는지 확인)
	System.out.println(noticeNo + "<--updateNoticeAction noticeNo");
	System.out.println(noticePw + "<--updateNoticeAction noticePw");
	System.out.println(noticeTitle + "<--updateNoticeAction noticeTitle");
	System.out.println(noticeContent + "<--updateNoticeAction noticeContent");
	
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 디버깅 코드(DB 접속 확인)
	System.out.println("updateNoticeAction DB접속성공"+conn);
	// 쿼리 작성(UPDATE [테이블] SET [열] = '변경할값' WHERE [조건])
	String sql = "update notice set notice_title = ?, notice_content = ?, updatedate = now() where notice_no = ? and notice_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1,noticeTitle);
	stmt.setString(2,noticeContent);
	stmt.setInt(3, noticeNo);
	stmt.setString(4, noticePw);
	//디버깅 코드(stmt의 저장된 쿼리 확인)
	System.out.println(stmt + "<--updateNoticeAction stmt");
	
	int row = stmt.executeUpdate();
	System.out.println(row + "<-updateNoticeAction row 수정 성공한 행의 수");
	
	/* redirection 수정 성공, 실패에 따른 페이지 이동
	* row == 1 : noticeOne.jsp 페이지 이동. 이동 시 noticeNo 전달
	* row == 0: updateNoticeForm.jsp 페이지 이동. 이동 시 noticeNo, msg 전달
	*/
	if(row == 0){
		String incorrectPw = URLEncoder.encode("비밀번호가 맞지않습니다","utf-8");
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+noticeNo+"&msg="+incorrectPw);
	}else if(row == 1){
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
	}else {
		System.out.println("error row값 : "+row);
	}
%>