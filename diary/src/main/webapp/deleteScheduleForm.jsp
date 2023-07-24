<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청값 유효성 검사
	// 값이 null,"" 이면 scheduleList.jsp 페이지로 리턴
	if(request.getParameter("scheduleNo")==null
		|| request.getParameter("scheduleDate")==null
		|| request.getParameter("scheduleNo").equals("")
		|| request.getParameter("scheduleDate").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	} 

	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	// 디버깅 코드
	System.out.println(scheduleNo + "deleteScheduleForm param scheduleNo");
	System.out.println(scheduleDate + "deleteScheduleForm param scheduleDate");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteScheduleForm.jsp</title>
<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
	<div class="main-container">
		<div class="cell-header">
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="cell-content">
			<!-- deleteScheduleAction.jsp 페이지에서 유효성 검사시 msg!=null 때 msg를 출력 -->
			<div class="container">
				<%
					String msg = request.getParameter("msg");
					if(msg!= null){
				%>
						<%=msg%>
				<%		
					}
				%>
			</div>
			
			<!-- 일정삭제 폼 -->
			<form action="./deleteScheduleAction.jsp" method="post">
				<input type="hidden" name="scheduleDate" value="<%=scheduleDate%>">
				<h3 class="container p-3">일정 삭제</h3>
				<div class="container p-3">
				<table class="table">
					<tr>
						<td>일정번호</td>
						<td>
							<input type="hidden" name="scheduleNo" value="<%=scheduleNo%>">
							<%=scheduleNo%>
						</td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td>
							<input type="password" name="schedulePw" class="form-control w-25">
						</td>
					</tr>
				</table>
				</div>
				<div class="container text-right">
					<button type="submit" class="btn">삭제</button>
					<button type="button" onclick="location.href='./noticeOne.jsp?noticeNo=<%=scheduleNo%>'" class="btn">취소</button>
				</div>
			</form>
		</div>
		<div class="cell-footer">
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
	
	
</body>
</html>