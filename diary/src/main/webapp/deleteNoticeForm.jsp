<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	/* request parameter values 유효성 검사
	* noticeNo의 값이 null, "" 이면 noticeList.jsp 페이지로 리턴
	*/
	if(request.getParameter("noticeNo")==null
		||request.getParameter("noticeNo").equals("")){
		response.sendRedirect("./noticeList.jsp");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// 디버깅 코드(parameter 값을 받았는지 확인)
	System.out.println(noticeNo + "deleteNoticeForm param noticeNo"); 
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<jsp:include page="/inc/link.jsp"></jsp:include>
<title>deleteNoticeForm</title>
</head>
<body>
	<div class="main-container">
		<div class="cell-header">
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="cell-content">
			<!-- deleteNoticeAction.jsp 페이지에서 유효성 검사시 msg!=null 때 msg를 출력 -->
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
			<!-- 공지삭제 폼 -->
			<form action="./deleteNoticeAction.jsp" method="post">
				<h3 class="container p-3">공지 삭제</h3>
				<div class="container p-3">
					<table class="table">
						<tr>
							<td>번호</td>
							<td>
								<!-- hidden : 안보이게 -->
								<input type="hidden" name="noticeNo" value="<%=noticeNo%>">
								<%=noticeNo%>
							</td>
						</tr>
						<tr>
							<td>비밀번호</td>
							<td>
								<input type="password" name="noticePw" class="form-control w-25">
							</td>
						</tr>
					</table>
				</div>
				<div class="container p-3 text-right">
					<button type="submit" class="btn">삭제</button>
					<button type="button" onclick="location.href='./noticeOne.jsp?noticeNo=<%=noticeNo%>'" class="btn">취소</button>
				</div>
			</form>
		</div>
		<div class="cell-footer">
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>