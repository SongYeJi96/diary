<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.Notice" %>
<%
	//한글이 깨질 수 있으므로 request 인코딩
	request.setCharacterEncoding("utf-8");

	/* 요청값 유효성 검사
	* noticeNo의 값이 null, ""일 경우 home.jsp로 리턴
	* return : 1) 코드진행종료 2) 반환값을 넘김
	*/
	if(request.getParameter("noticeNo") == null
		|| request.getParameter("noticeNo").equals("")){
		response.sendRedirect("./home.jsp"); 
		return;  
	}
	// 값을 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// DB 설정 
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 쿼리 작성
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ?"; 
	PreparedStatement stmt = conn.prepareStatement(sql); // ?(1)
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + "<--noticeOne.jsp stmt");
	ResultSet rs = stmt.executeQuery();
	
	// 한 행이 출력, vo.Notice 객체 생성 하여 값 저장
	Notice notice = null;
	if(rs.next()){
		notice = new Notice();
		notice.noticeTitle = rs.getString("notice_title");
		notice.noticeContent = rs.getString("notice_content");
		notice.noticeWriter = rs.getString("notice_Writer");
		notice.createdate = rs.getString("createdate");
		notice.updatedate = rs.getString("updatedate");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeOne.jsp</title>
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
    background-color:#222222;
    color:#FFFFFF;}
    .right{text-align:right;}
</style>
</head>
<body>
	<div class="container p-3"><!-- 메인메뉴 -->
		<a href="./home.jsp" class="btn">홈</a>
		<a href="./noticeList.jsp" class="btn">공지</a>
		<a href="./scheduleList.jsp" class="btn">일정</a>
	</div>

	<div class="container p-3">	
	<h3>공지 상세</h3>
		<table class="table table-sm w-aoto">
			<tr>
				<td>번호</td>
				<td><%=noticeNo%></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><%=notice.noticeTitle%></td>
			</tr>
			<tr>
				<td>공지 내용</td>
				<td><%=notice.noticeContent%></td>
			</tr>
			<tr>
				<td>작성인</td>
				<td><%=notice.noticeWriter%></td>
			</tr>
			<tr>
				<td>등록일</td>
				<td><%=notice.createdate.substring(0,10)%></td>
			</tr>
			<tr>
				<td>수정일</td>
				<td><%=notice.updatedate.substring(0,10)%></td>
			</tr>
		</table>
	</div>
	<div class="container p-3 right">
		<a href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn">수정</a>
		<a href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo%>" class="btn">삭제</a>
	</div>
</body>
</html>