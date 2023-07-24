<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm.jsp</title>
<jsp:include page="/inc/link.jsp"></jsp:include>
</head>
<body>
	<div class="main-container">
		<div class="cell-header">
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<div class="cell-content">
			<!-- insertNoticeAction.jsp 페이지에서 들어온 msg의 값이 null이 아니면 msg 출력 -->
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
			<!-- 공지입력 폼 -->
			<form action="./insertNoticeAction.jsp" method="post">
				<h3 class="container p-3">공지 작성</h3>
				<div class="container p-3">
					<table class="table">
						<tr>
							<td>제목</td>
							<td>
								<input type="text" name="noticeTitle" class="form-control">
							</td>
						</tr>
						<tr>
							<td>공지</td>
							<td>
								<textarea rows="10" name="noticeContent" class="form-control"></textarea>
							</td>
						</tr>
						<tr>
							<td>작성인</td>
							<td>
								<input type="text" name="noticeWriter" class="form-control w-25">
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
				<div class="container text-right">
					<button type="submit" class="btn">입력</button>
				</div>
			</form>
		</div>
		<div class="cell-footer">
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>