<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap 5 최신 버전 사용 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
	// user 객체가 존재하는지 확인하여 콘솔에 출력
	var user = {
	    loginId: "${user.loginId}",
	    nickname: "${user.nickname}",
	    pwd: "${user.pwd}"
	};
	console.log("User data from server:", user);
	
	let isIdChecked = false;

	function checkId() {
		const loginId = document.getElementById("loginId").value.trim();
		console.log("join.jsp loginId 호출 : " + loginId);

		// 아이디 유효성 검사 (영어, 숫자, 특수문자만 허용)
		const idPattern = /^[a-zA-Z0-9!@#$%^&*()_+[\]{}|\\;:'",.<>/?`~]+$/;
		if (!idPattern.test(loginId)) {
			document.getElementById("idCheck").innerText = "사용할 수 없는 아이디입니다. (영어, 숫자, 특수문자만 가능)";
			document.getElementById("idCheck").style.color = "red";
			isIdChecked = false;
			return;
		}

		if (loginId === "") {
			document.getElementById("idCheck").innerText = "아이디를 입력하세요.";
			document.getElementById("idCheck").style.color = "red";
			return;
		}

		var xhr = new XMLHttpRequest();
		xhr.open("GET",
				"${pageContext.request.contextPath}/user/checkId?loginId="
						+ encodeURIComponent(loginId), true);
		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4 && xhr.status === 200) {
				if (xhr.responseText === "사용 가능한 아이디입니다.") {
					document.getElementById("idCheck").innerText = xhr.responseText;
					document.getElementById("idCheck").style.color = "green";
					isIdChecked = true;
				} else {
					document.getElementById("idCheck").innerText = xhr.responseText;
					document.getElementById("idCheck").style.color = "red";
					isIdChecked = false;
				}
			}
		};
		xhr.send();
	}

	function resetIdCheck() {
		isIdChecked = false;
		document.getElementById("idCheck").innerText = "";
	}

	function joinCheck() {
		const loginId = document.joinForm.loginId.value.trim();
		const pwd = document.joinForm.pwd.value.trim();
		const nickname = document.joinForm.nickname.value.trim();
		
		console.log(`${pageContext.request.contextPath}`);
		if (!loginId) {
			alert("아이디를 입력하세요.");
			return false;
		}

		if (!isIdChecked) {
			alert("아이디 중복 체크를 눌러주세요.");
			return false;
		}

		if (!pwd) {
			alert("비밀번호를 입력하세요.");
			return false;
		}

		if (!nickname) {
			alert("이름을 입력하세요.");
			return false;
		}

		return true;
	}
</script>
</head>
<body>

	<div class="container mt-5">
		<div class="row justify-content-center">
			<div class="col-md-6">
				<div class="card shadow-sm">
					<div class="card-header text-center">
						<h3>회원가입</h3>
					</div>
					<div class="card-body">
						<form name="joinForm"
							action="${pageContext.request.contextPath}/user/join"
							onsubmit="return joinCheck();" method="post">
							<div class="mb-3">
								<label for="loginId" class="form-label">ID:</label>
								<div class="input-group">
									<input type="text" name="loginId" id="loginId"
										class="form-control" maxlength="20" placeholder="아이디를 입력하세요."
										oninput="resetIdCheck()">
									<button type="button" class="btn btn-outline-secondary"
										onclick="checkId()">아이디 체크</button>
								</div>
								<small id="idCheck" class="form-text" style="color: red;"></small>
							</div>

							<div class="mb-3">
								<label for="pwd" class="form-label">Password:</label> <input
									type="password" name="pwd" class="form-control" maxlength="20"
									placeholder="비밀번호를 입력하세요.">
							</div>

							<div class="mb-3">
								<label for="nickname" class="form-label">Name:</label> <input
									type="text" name="nickname" class="form-control" maxlength="20"
									placeholder="이름을 입력하세요.">
							</div>

							<div class="d-flex justify-content-between">
								<input type="submit" value="회원가입" class="btn btn-primary">
								<button type="button"
									onclick="location.href='${pageContext.request.contextPath}/user/login'"
									class="btn btn-secondary">로그인 페이지</button>
								<input type="reset" value="취소" class="btn btn-danger">
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
