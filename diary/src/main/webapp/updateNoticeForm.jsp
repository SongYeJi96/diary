<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="vo.Notice" %>
<%
	// 요청값 유효성 검사
	// null, "" 값이 들어오편 noticeList.jsp 페이지로 리턴
	if(request.getParameter("noticeNo")==null
		|| request.getParameter("noticeNo").equals("")){		
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	//request.getParameter로 받은 값을 변수에 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("updateNoticeForm.jsp 접속 성공"+conn);
	// 쿼리 작성
	String sql = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate, notice_pw from notice where notice_no = ?"; 
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	// 디버깅 코드(stmt의 저장된 쿼리 확인)
	System.out.println(stmt + "<--updateNoticeForm.jsp stmt");
	ResultSet rs = stmt.executeQuery();
	
	// 1행을 출력, vo.notice의 객체를 만들어 값 저장
	Notice notice = null;
	if(rs.next()){
		notice = new Notice();
		notice.noticeTitle = rs.getString("notice_title");
		notice.noticeContent = rs.getString("notice_content");
		notice.noticeWriter = rs.getString("notice_writer");
		notice.noticePw = rs.getString("notice_pw");
		notice.createdate = rs.getString("createdate");
		notice.updatedate = rs.getString("updatedate");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateNoticeForm</title>
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
    button.btn{
    display:inline-block;
    width:100px;
    line-height:20px;
    text-align:center;
    background-color:#333333;
    color:#FFFFFF;}
    .right{text-align:right;}
    .none{border-style: none;}
</style>
</head>
<body>
	
	<div class="container p-3"><!-- 메인메뉴 -->
		<a href="./home.jsp" class="btn">홈</a>
		<a href="./noticeList.jsp" class="btn">공지</a>
		<a href="./scheduleList.jsp" class="btn">일정</a>
	</div>
	<div class="container p-3">
	<!-- updateNoticeAction.jsp 페이지에서 들어온 msg의 값이 null이 아니면 msg 출력 -->
		<%
			String msg = request.getParameter("msg");
			if(msg!= null){
		%>
				<%=msg%>
		<%		
			}
		%>
	</div>
	<form action="./updateNoticeAction.jsp" method="post">
		<div class="container p-3">
		<h3>정보 수정</h3>
			
		</div>
		<div class="container p-3">
			<table class="table table-sm">
				<tr>
					<td>번호</td>
					<td>
						<input type="number" name="noticeNo" value="<%=noticeNo%>" readonly="readonly" class="none">
					</td>
				</tr>
				<tr>
					<td>제목</td>
					<td>
						<input type="text" name="noticeTitle" value="<%=notice.noticeTitle%>" >
					</td>
				</tr>
				<tr>
					<td>공지</td>
					<td>
						<textarea rows="5" cols="80" name="noticeContent"><%=notice.noticeContent%>
						</textarea>
					</td>
				</tr>
				<tr>
					<td>작성인</td>
					<td>
						<%=notice.noticeWriter%>
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" name="noticePw"> 
					</td>
				</tr>
				<tr>
					<td>작성일</td>
					<td>
						<%=notice.createdate.substring(0,10)%>
					</td>
				</tr>
				<tr>
					<td>수정일</td>
					<td>
						<%=notice.updatedate.substring(0,10)%>
					</td>
				</tr>
			</table>
		</div>
		<div class="container right">
			<button type="submit" class="btn">수정</button>
			<button type="button" onclick="location.href='noticeList.jsp'" class="btn">뒤로가기</button>
		</div>
	</form>
</body>
</html>