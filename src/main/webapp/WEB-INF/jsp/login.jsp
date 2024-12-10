<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap 5 최신 버전 사용 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
	window.onload = function() {
		const urlParams = new URLSearchParams(window.location.search);
		if (urlParams.get('error') === 'true') {
			alert("아이디, 비밀번호를 확인해주세요.");
		}
	};

	function loginCheck() {
		const loginId = document.loginForm.loginId.value.trim();
		const pwd = document.loginForm.pwd.value.trim();

		if (!loginId && !pwd) {
			alert("아이디를 입력하세요.");
			return false;
		} else if (!pwd) {
			alert("비밀번호를 입력하세요.");
			return false;
		}
		return true;
	}
</script>
</head>
<body>

	<div class="container mt-5">
		<div class="row justify-content-center">
			<div class="col-md-4">
				<div class="card shadow-sm">
					<div class="card-header text-center">
						<h3>로그인</h3>
					</div>
					<div class="card-body">
						<form name="loginForm"
							action="${pageContext.request.contextPath}/user/login"
							method="post" onsubmit="return loginCheck();">
							<div class="mb-3">
								<label for="loginId" class="form-label">아이디</label> <input
									type="text" name="loginId" class="form-control" id="loginId"
									maxlength="20" placeholder="아이디">
							</div>
							<div class="mb-3">
								<label for="pwd" class="form-label">비밀번호</label> <input
									type="password" name="pwd" class="form-control" id="pwd"
									maxlength="20" placeholder="비밀번호">
							</div>
							<div class="d-flex justify-content-between">
								<input type="submit" value="로그인" class="btn btn-primary">
								<button type="button"
									onclick="location.href='${pageContext.request.contextPath}/user/join'"
									class="btn btn-secondary">회원가입</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Bootstrap JS 추가 -->
	<script
		src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>

</body>
</html>
