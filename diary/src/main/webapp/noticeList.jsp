<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.Notice"%>

<%
	// 요청 분석(currentPage)
	// 현재페이지
	int currentPage =1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + "<--currentPage");
	
	// 페이지당 출력할 행의 수
	int rowPerPage =10;
	
	// 시작 행 번호
	/*
			currentPage		startRow(rowPerPage 10일때)
			1				0	<-- (currentPage-1)*rowPerPage
			2				10
			3				20
			4				30
	*/
	int startRow = (currentPage-1)*rowPerPage; // 1page 일때만 startRow가 0
	
	//db 설정
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 쿼리 작성
	String sql = "select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	// 디버깅 코드(stmt의 저장된 쿼리 확인)
	System.out.println(stmt + "<--noticeList.jsp stmt");
	
	// 출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();
	
	/* 자료구조 ResultSet 타입을 일반적인 자료구조타입(자바 배열  or 기본 API 자료구조타입(List,Set,Map))으로 변환
	* ResultSet의 rs.next() 한번만 사용할 수 있고 누구나 사용할 수 있는 타입으로 변환시키는 것이 좋다.
	* ResultSet --> ArrayList<Notice>
	*/
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
	
	/* 마지막 페이지
	* totalRow : 전체 행의 수를 담을 변수, 0으로 초기화.
	* if 문 사용하여 다음 행의 값이 있을 때가지 totalRow의 행의 수를 저장.
	* lastPage : 마지막 페이지를 담을 변수. totalRow(전체 행의 수) / rowPerPage(한 페이지에 출력되는 수)
	* totalRow % rowPerPage의 나머지가 0이 아닌경우 lastPage +1을 해야한다.
	*/
	String sql2 ="select count(*) from notice";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	ResultSet rs2 = stmt2.executeQuery();
	
	int totalRow = 0;
	if(rs2.next()){  
		totalRow = rs2.getInt("count(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage +1;
	}
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeList.jsp</title>
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
    .right{text-align:right;}
    thead{background-color: #E7E7E7;}
    .tdtitle:hover{
    color:#0100FF;
    background-color: ;
    cursor: pointer;}
</style>
</head>
<body>
	<div class="container p-3"><!-- 메인메뉴 -->
		<a href="./home.jsp" class="btn">홈</a>
		<a href="./noticeList.jsp" class="btn">공지</a>
		<a href="./scheduleList.jsp" class="btn">일정</a>
	</div>
	
	<div class="container p-3">
	<table class="table table_sm">
		<thead>
			<tr>
				<th>번호</th>
				<th>등록일</th>
			</tr>
		</thead>
		<%
			for(Notice n:noticeList){
		%>
			<tbody>
				<tr onclick="location.href='./noticeOne.jsp?noticeNo=<%=n.noticeNo%>'">
					<td class="tdtitle"><%=n.noticeTitle%></td>
					<td><%=n.createdate.substring(0,10)%></td>
				</tr>
			</tbody>
		<%		
			}
		%>
	</table>
	</div>
	<div class="container right">
		<a href="./insertNoticeForm.jsp" class="btn">공지 등록</a>
	</div>
	<div class="container p-3 text-center">
		<%
			if(currentPage > 1) {
		%>
				<a href ="./noticeList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%		
			}
		%>
				<%=currentPage %>
		<%
			if(currentPage < lastPage){
		%>
				<a href ="./noticeList.jsp?currentPage=<%=currentPage+1%>">다음</a>
		<%
		}
		%>
	</div>
	
</body>
</html>