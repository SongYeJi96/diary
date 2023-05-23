<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.util.*" %>
<%@ page import ="java.sql.*" %>
<%@ page import ="vo.*" %>
<%
	// 오늘 날짜 연, 월 변수 0으로 초기화 
	int targetYear = 0;
	int targetMonth = 0;
	
	/* 년 or 월이 요청값에 넘어오지 않으면 오늘 날짜의 년/월값으로 받는다
	* 월은 0부터 시작. 출력값에서 1로 보이게 수정해야함
	*/
	if(request.getParameter("targetYear") == null
		|| request.getParameter("targetMonth") == null){
		
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH); 
	} else {
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	// 디버깅 코드
	System.out.println(targetYear + "<-- scheduleList param targetyear");
	System.out.println(targetMonth + "<-- scheduleList param targetmonth");
	
	// 오늘 날짜
	Calendar today = Calendar.getInstance();
	int todaydate = today.get(Calendar.DATE);
	
	// targetMonth 1일
	Calendar firstDay = Calendar.getInstance();
	firstDay.set(Calendar.YEAR, targetYear);
	firstDay.set(Calendar.MONTH, targetMonth); 
	firstDay.set(Calendar.DATE,1);
	
	// 내부적으로 바뀐 값을 받아서 저장. ex) 23년 13월 --> Calendar API 24년 1월 변경
	targetYear=firstDay.get(Calendar.YEAR);
	targetMonth=firstDay.get(Calendar.MONTH);
	// 디버깅 코드
	System.out.println(targetYear + "<-- scheduleList targetyear API");
	System.out.println(targetMonth + "<-- scheduleList targetmonth API");
	
	// 달의 첫번째 요일이 몇번째 요일인지. 일요일 -> 1 토요일 -> 7
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK);  
	// 1일 앞의 공백칸의 수
	int startBlank = firstYoil -1;
	// targetMonth 마직막일. 현재가지고 있는 달의 가장 큰 할당 가능한 숫자
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	
	// 출력하고자 하는 년/월/마지막 날짜
	int endDateNum = firstDay.getActualMaximum(Calendar.DATE);
	System.out.println(endDateNum + "<-- endDateNum");
	
	// 출력하고자 하는 전달 년/월/마지막 날짜
	int lastMonthNum = 0;
	Calendar lastMonth = Calendar.getInstance();
	lastMonth.set(Calendar.YEAR, targetYear);
	lastMonth.set(Calendar.MONTH, targetMonth);
	lastMonthNum = lastMonth.getActualMaximum(Calendar.DATE);
	
	// 전체 TD를 7로 나눈 나머지 값:0
	int endBlank = 0;
	if ((startBlank+lastDate) % 7 != 0){
		endBlank = 7-(startBlank+lastDate)%7;
	}
	// 전체 TD의 개수
	int totalTd = 0;
	totalTd = startBlank + lastDate + endBlank;
	System.out.println(totalTd+"<-- totlaTd");
	
	// DB 설정
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	// 쿼리 작성
	String sql="select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo,1,5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by month(schedule_date) asc";
	PreparedStatement stmt = conn.prepareStatement(sql); //?(1-2)
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth+1); // 마리아DB에서 월은 1~12까지 저장 됨으로 targetMonth +1
	System.out.println(stmt + "<--scheduleList.jsp stmt");
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 전체날짜가 아닌 월값만 들어있음
		s.scheduleMemo = rs.getString("scheduleMemo"); // 전체메모가 아닌 5글자만 가져온다.
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>scheduleList.jsp</title>
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
    td:hover{
    background-color: #EAEAEA;
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
		<h1><%=targetYear%>년 <%=targetMonth+1%>월</h1>
	</div>
	<div class="container right">
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>" class="btn">이전달</a>
		<a href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>" class="btn">다음달</a>
	</div>
	<div class="container p-3">
		<table class="table table-sm">
			
			<tr>
				<th class="text-danger">일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th class="text-important">토</th>
			</tr>
			
			<tr>
				<%
					for(int i=0; i<totalTd; i+=1){
						int num = i-startBlank+1;
						if(i != 0 && i%7==0){
				%>
							</tr><tr>
				<%
						} 
				%>
				<%
						String tdStyle="";
						if(num>0 && num<=lastDate){
							if(today.get(Calendar.YEAR) == targetYear // 오늘 날짜
								&& today.get(Calendar.MONTH) == targetMonth
								&& today.get(Calendar.DATE) == num){
								tdStyle = "background-color:#E7E7E7;";
							}
							
							if(i%7==0){// 일요일 글자 : 빨강
				%>
									<td style="<%=tdStyle%>" onclick="location.href='./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>'" class="text-danger">
										<div><!-- 일 숫자 -->
												<%=num%>
										</div>
										<div><!-- 일정 메모(5글자만) -->
											<%
												for(Schedule s : scheduleList){
													if(num==Integer.parseInt(s.scheduleDate)){
											%>
												<div style="color:<%=s.scheduleColor%>">
													<%=s.scheduleMemo%>
												</div>
											<%		
													}
												}
											%>
										</div>
									</td>
				<%			
							} else if(i%7==6){ // 토요일 : 파랑
				%>
									<td style="<%=tdStyle%>" onclick="location.href='./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>'" class="text-important">
										<div><!-- 일 숫자 -->
												<%=num%>
										</div>
										<div><!-- 일정 메모(5글자만) -->
											<%
												for(Schedule s : scheduleList){
													if(num==Integer.parseInt(s.scheduleDate)){
											%>
												<div style="color:<%=s.scheduleColor%>">
													<%=s.scheduleMemo%>
												</div>
											<%		
													}
												}
											%>
										</div>
									</td>
				
				<%				
							} else{ // 나머지 : 검정
				%>
								<td style="<%=tdStyle%>" onclick="location.href='./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>'" class="text-dark">
									<div><!-- 일 숫자 -->
											<%=num%>
									</div>
									<div><!-- 일정 메모(5글자만) -->
										<%
											for(Schedule s : scheduleList){
												if(num==Integer.parseInt(s.scheduleDate)){
										%>
											<div style="color:<%=s.scheduleColor%>">
												<%=s.scheduleMemo%>
											</div>
										<%		
												}
											}
										%>
									</div>
								</td>
				<%				
							}
				%>
				<%		
						} else if(num<1){// 1일 앞의 공란 저번달 일 나오게
				%>			
								<td class="text-muted">
										<%=lastMonthNum + num %>
								</td>
					<%
							} else{// 마지막 일 이후의 공란 다음달 일 나오게
					%>
									<td class="text-muted">
										<%=num-endDateNum %>
									</td>
					<%				
							}
					}
				%>
								
			</tr>
		</table>
	</div>
</body>
</html>