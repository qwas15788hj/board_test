<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script><%-- 
<!-- Bootstrap JS 추가 -->
<script	src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"> --%>
<!-- Bootstrap 5 최신 버전 사용 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
	$(document).ready(function() {
	    // JSP에서 전달된 메시지를 alert로 표시
	    <% if (request.getAttribute("errorMessage") != null) { %>
	        alert("<%= request.getAttribute("errorMessage") %>");
	    <% } %>
	});

	function validateForm() {
		const pwd = document.getElementById("password").value;
		const confirmPwd = document.getElementById("confirmPassword").value;

		if (pwd !== confirmPwd) {
			alert("비밀번호가 일치하지 않습니다. 다시 입력해주세요.");
			return false;
		}
		return true;
	}
	
	document.addEventListener("DOMContentLoaded", function() {
	    let offset = 0; // 초기 offset 값
	    
	    // 게시글을 로드하는 함수
	    function loadArticles(offset) {
	        fetch(`${pageContext.request.contextPath}/article/userArticles?offset=\${offset}`, {
	            method: 'GET',
	            headers: {
	                'Content-Type': 'application/x-www-form-urlencoded'
	            }
	        })
	        .then(response => {
	            if (!response.ok) {
	                throw new Error('게시글을 불러오는 도중 오류가 발생했습니다.');
	            }
	            return response.json();
	        })
	        .then(articles => {
	            // 가져온 게시글을 콘솔에 출력
	            console.log("Fetched Articles:", articles);
	            
	            const carouselInner = document.getElementById("carouselInner");

                // 매 5개씩 슬라이드를 나눠서 생성
                let chunkSize = 5;
                for (let i = 0; i < articles.length; i += chunkSize) {
                	const chunk = articles.slice(i, i + chunkSize); // 5개씩 슬라이싱
                	// 게시글 그룹을 추가할 HTML 요소 생성
                	const articleGroupDiv = document.createElement("div");
                	articleGroupDiv.className = i === 0 ? "carousel-item active" : "carousel-item"; // 첫 번째 요소를 active로 설정
                	
                	// 각 그룹 내에 개별 게시글 추가
                	let articlesHtml = '<div class="row d-flex justify-content-center">';
                	chunk.forEach((article) => {
                		const createdAt = new Date(article.createdAt).toLocaleString();
                		articlesHtml += `
                			<div class="col-md-2" style="margin: 5px;">  <!-- 컬럼 간의 간격 조정 -->
	                		    <div class="card" style="width: 10rem; margin: 5px;">  <!-- 카드의 크기를 조정 -->
	                		        <div class="card-body" style="display: flex; flex-direction: column;">
	                		            <a href="${pageContext.request.contextPath}/article/articleDetail/\${article.articleId}" class="card-title" style="font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-decoration: none; color: black;">
	                		                \${article.title}
	                		            </a>
	                		            <p class="card-text">조회수: \${article.views}</p>
	                		            <small class="text-muted">\${createdAt}</small>
	                		        </div>
	                		    </div>
	                		</div>
                		`;
                		});
                	articlesHtml += '</div>';
                	
                	// 생성한 그룹의 HTML을 설정
                	articleGroupDiv.innerHTML = articlesHtml;
                	
                	// 생성한 게시글 그룹을 carousel-inner에 추가
                	carouselInner.appendChild(articleGroupDiv);
                	
                	// 디버깅을 위한 콘솔 로그
                	console.log("게시글 처리 중:", chunk);
                }
                
                $('.carousel').carousel({
                    interval: 2000, // 3초마다 자동 슬라이드
                    ride: 'carousel' // 자동으로 슬라이드가 시작되도록 설정
                });

	        })
	        .catch(error => {
	            console.error("Error while fetching articles:", error.message);
	        });
	    }

	    // 페이지 로드 시 초기 게시글 로드
	    loadArticles(offset);
	});

	document.addEventListener("DOMContentLoaded", function () {
        const togglePassword = document.getElementById("togglePassword");
        const passwordField = document.getElementById("password");

        const toggleConfirmPassword = document.getElementById("toggleConfirmPassword");
        const confirmPasswordField = document.getElementById("confirmPassword");

        // 비밀번호 표시/숨기기
        togglePassword.addEventListener("click", function () {
            const isPassword = passwordField.type === "password";
            passwordField.type = isPassword ? "text" : "password";
            this.querySelector("i").classList.toggle("fa-eye-slash", !isPassword);
            this.querySelector("i").classList.toggle("fa-eye", isPassword);
        });

        toggleConfirmPassword.addEventListener("click", function () {
            const isPassword = confirmPasswordField.type === "password";
            confirmPasswordField.type = isPassword ? "text" : "password";
            this.querySelector("i").classList.toggle("fa-eye-slash", !isPassword);
            this.querySelector("i").classList.toggle("fa-eye", isPassword);
        });

    });

</script>
<style>
    /* 숫자 항목의 스타일을 간단히 정의 */
    .number-item {
        font-size: 24px;
        padding: 20px;
        text-align: center;
        border: 1px solid #ddd;
        border-radius: 5px;
        width: 60px;
    }
    /* 이전 및 다음 버튼의 스타일을 추가하여 시각적으로 더 잘 보이게 수정 */
    .carousel-control-prev,
    .carousel-control-next {
        background-color: rgba(0, 0, 0, 0.5);
        border-radius: 50%;
        width: 40px;
        height: 40px;
        top: 50%;
        transform: translateY(-50%);
    }
    /* Carousel 크기를 마이페이지와 동일하게 설정 */
    #numberCarousel {
        width: 100%;
        max-width: 1000px;
        margin: 20px auto;
    }
</style>

</head>
<body>

	<div class="container mt-5">
		<div class="card" style="max-width: 1000px; margin: 0 auto;">
			<div class="card-header text-center">
				<h3>마이페이지</h3>
			</div>
			<div class="card-body">
				<form action="${pageContext.request.contextPath}/user/modify"
					method="post" onsubmit="return validateForm();">
					<div class="mb-3">
						<label for="loginId" class="form-label"><strong>아이디:</strong></label>
						<span>${user.loginId}</span> <input type="hidden" name="userId"
							value="${user.id}">
					</div>

					<div class="mb-3">
					    <label for="password" class="form-label"><strong>변경할 비밀번호:</strong></label>
					    <div class="input-group">
					        <input type="password" id="password" name="pwd" class="form-control"
					               placeholder="비밀번호를 입력하세요"
					               oninput="updatePasswordStars(this, 'passwordStars')" required>
					        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
					            <i class="fas fa-eye-slash"></i>
					        </button>
					    </div>
					    <div id="passwordStars" style="font-family: monospace; color: #888;"></div>
					</div>
					
					<div class="mb-3">
					    <label for="confirmPassword" class="form-label"><strong>비밀번호 확인:</strong></label>
					    <div class="input-group">
					        <input type="password" id="confirmPassword" class="form-control"
					               placeholder="비밀번호를 다시 입력하세요"
					               oninput="updatePasswordStars(this, 'confirmPasswordStars')" required>
					        <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword">
					            <i class="fas fa-eye-slash"></i>
					        </button>
					    </div>
					    <div id="confirmPasswordStars" style="font-family: monospace; color: #888;"></div>
					</div>

					<div class="mb-3">
						<label for="nickname" class="form-label"><strong>이름:</strong></label>
						<input type="text" name="nickname" id="nickname"
							class="form-control" value="${user.nickname}"
							placeholder="이름을 입력하세요" required>
					</div>

					<!-- 버튼을 가로로 배치 -->
					<div class="d-flex justify-content-between">
						<button type="submit" class="btn btn-primary">수정하기</button>

						<button type="button"
							onclick="location.href='${pageContext.request.contextPath}/article/articleList'"
							class="btn btn-secondary">게시글 목록으로</button>
					</div>
				</form>
				<!-- 회원탈퇴 버튼 -->
				<form action="${pageContext.request.contextPath}/user/remove"
					method="post" class="d-inline">
					<!-- <input type="hidden" name="_method" value="DELETE"> -->
					<input type="hidden" name="userId" value="${user.id}">
					<button type="submit" class="btn btn-danger">회원탈퇴</button>
				</form>
			</div>
		</div>
	</div>

	<div class="container mt-5">
		<div class="card" style="max-width: 1000px; margin: 0 auto;">
	        <div class="card-header">
	            <h5 class="mb-0">작성한 글</h5> <!-- 제목을 왼쪽 위에 표시 -->
	        </div>
	        <div class="card-body">
			    <c:choose>
			        <c:when test="${articleCount > 0}">
			            <!-- 게시글이 있는 경우 캐러셀을 표시 -->
			            <div id="numberCarousel" class="carousel slide" data-bs-ride="carousel">
			                <div class="carousel-inner" id="carouselInner">
			                    <!-- 이곳에 JavaScript에서 게시글을 추가할 것입니다. -->
			                </div>
			
			                <!-- 이전 버튼 -->
			                <button class="carousel-control-prev" type="button" data-bs-target="#numberCarousel" data-bs-slide="prev" id="prevButton">
			                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
			                    <span class="visually-hidden">Previous</span>
			                </button>
			
			                <!-- 다음 버튼 -->
			                <button class="carousel-control-next" type="button" data-bs-target="#numberCarousel" data-bs-slide="next" id="nextButton">
			                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
			                    <span class="visually-hidden">Next</span>
			                </button>
			            </div>
			        </c:when>
			        <c:otherwise>
			            <!-- 게시글이 없는 경우 메시지 표시 -->
			            <p class="text-center mt-3"><strong>작성한 글이 없습니다!</strong></p>
			        </c:otherwise>
			    </c:choose>
			</div>
		</div>
	</div>
		

</body>
</html>
