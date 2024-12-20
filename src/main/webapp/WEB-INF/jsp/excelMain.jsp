<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>엑셀 업로드 테스트</h1>
	<form action="${pageContext.request.contextPath}/excel/addExcel" method="POST" enctype="multipart/form-data">
		<input type="file" name="file">
		<input type="submit" value="업로드 !" />
	</form>
	<form action="${pageContext.request.contextPath}/excel/download" method="get">
		<button type="submit">다운로드</button>
	</form>
</body>
</html>