<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글 수정</title>

    <!-- jQuery 라이브러리 추가 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
	<!-- Bootstrap 5 최신 버전 사용 -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- CKEditor CDN 방식으로 JavaScript 추가 -->
    <script src="//cdn.ckeditor.com/4.19.0/full/ckeditor.js"></script>
    
    <style>
        .marker {
            background-color: yellow; /* 배경색을 노란색으로 설정 */
        }
    </style>
</head>
<body class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header text-center">
                    <h3>글 수정</h3>
                </div>
                <div class="card-body">
                    <%-- <form id="editForm" action="${pageContext.request.contextPath}/article/update/${article.articleId}" method="post"> --%>
                        <div class="mb-3">
                            <label for="title" class="form-label"><strong>제목:</strong></label>
                            <input type="text" name="title" id="title" class="form-control" value="${article.title}" required readonly>
                        </div>

                        <div class="mb-3">
                            <label for="content" class="form-label"><strong>내용:</strong></label>
                            <!-- CKEditor가 적용될 textarea -->
                            <textarea name="content" id="content" rows="10" style="width: 100%; height: 300px;" class="form-control">
                                <c:out value="${article.content}" escapeXml="false"/>
                            </textarea>
                        </div>
                        
                        <div class="d-flex align-items-center mb-3">
						    <label class="form-label me-3"><strong>첨부파일:</strong></label>
						    <button type="button" class="btn btn-primary" onclick="document.getElementById('fileUpload').click()">파일 선택</button>
						</div>
						<!-- 파일 입력 -->
						<input type="file" id="fileUpload" class="d-none" accept=".txt,.png,.jpg,.jpeg,.gif,.mp4,.avi,.mov" onchange="handleFileUpload()" multiple />
						
						<!-- 파일 목록을 표시할 div -->
						<div id="fileList" class="mt-3"></div>
                        
                        <div class="d-flex justify-content-between">
                            <button type="button" class="btn btn-primary" onclick="submitContents()">수정 저장</button>
                            <button type="button" class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/article/articleList?pageIndex=${pageIndex}&searchCondition=${searchCondition}&searchKeyword=${searchKeyword}&timeRange=${timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}'">돌아가기</button>
                        </div>
                    <!-- </form> -->
                </div>
            </div>
        </div>
    </div>

    <!-- CKEditor 초기화 스크립트 -->
    <script type="text/javascript">
        $(function () {
            CKEDITOR.replace('content', {
                filebrowserUploadUrl: '${pageContext.request.contextPath}/article/image/upload',
                removePlugins: 'exportpdf', // exportpdf 플러그인 제거
                on: {
                    instanceReady: function () {
                        setTimeout(function() {
                            var warningBanner = document.getElementById('cke_notifications_area_content');
                            if (warningBanner) {
                                warningBanner.style.display = 'none';
                            }
                        }, 1); // 0.5초 후 실행
                    }
                }
            });
        });

/*         function submitContents() {
            // CKEditor 내용 동기화
            CKEDITOR.instances.content.updateElement();

            // 제목과 내용의 유효성 검사
            const title = document.getElementById("title").value.trim();
            const content = document.getElementById("content").value.trim();

            if (title === "") {
                alert("제목을 입력하세요.");
                document.getElementById("title").focus();
                return false;
            }

            if (content === "" || content === "<br>" || content === "<br/>" || content === "<p>&nbsp;</p>") {
                alert("내용을 입력하세요.");
                return false;
            }

            // 유효성 검사를 통과하면 폼 제출
            document.getElementById("editForm").submit();
        } */
        function submitContents() {
            // CKEditor 내용 동기화
            CKEDITOR.instances.content.updateElement();

            const title = document.getElementById("title").value.trim();
            const content = document.getElementById("content").value.trim();

            if (title === "") {
                alert("제목을 입력하세요.");
                document.getElementById("title").focus();
                return;
            }

            if (content === "" || content === "<br>" || content === "<br/>" || content === "<p>&nbsp;</p>") {
                alert("내용을 입력하세요.");
                return;
            }

            // FormData 생성
            const formData = new FormData();
            formData.append("content", content);
            
            // 기존 파일 정보를 추가 (fileUrl만 전달)
            const existingFiles = uploadedFiles.filter(file => file.id);
            if (existingFiles.length > 0) {
                existingFiles.forEach((file, index) => {
                    formData.append("existingFiles", file.id);
                });
            } else {
                formData.append("existingFiles", ""); // 빈 값을 전송
            }

            // 새로 선택된 파일만 추가
            const newFiles = uploadedFiles.filter(file => file instanceof File);
            newFiles.forEach((file, index) => {
                formData.append("files", file); // 서버에서 MultipartFile[]로 받을 수 있음
            });

            // 서버로 데이터 전송
            fetch("${pageContext.request.contextPath}/article/update/${article.articleId}", {
                method: "POST",
                body: formData
            })
            .then(response => response.json()) // JSON으로 반환된 데이터 파싱
            .then(data => {
                if (data.status === "success") {
                    // 검색 조건을 유지하면서 리스트 페이지로 이동
                    const pageIndex = data.pageIndex;
                    const searchCondition = encodeURIComponent(data.searchCondition);
                    const searchKeyword = encodeURIComponent(data.searchKeyword);
                    const timeRange = encodeURIComponent(data.timeRange);
                    const sortBy = encodeURIComponent(data.sortBy);
                    const sortOrder = encodeURIComponent(data.sortOrder);

                    const url = `${pageContext.request.contextPath}/article/articleList?pageIndex=${pageIndex}&searchCondition=${searchCondition}&searchKeyword=${searchKeyword}&timeRange=${timeRange}&sortBy=${sortBy}&sortOrder=${sortOrder}`;
                    location.href = url;
                } else {
                    alert(data.message || "서버 오류가 발생했습니다.");
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("오류가 발생했습니다.");
            });
        }

        
        let uploadedFiles = [];

        // 서버에서 전달받은 기존 파일 목록 초기화
        window.onload = function () {
            uploadedFiles = [
                <c:forEach var="file" items="${articleFiles}" varStatus="status">
                    {	
                    	id : "${file.id}",
                    	name: "${file.fileName}",
                        size: "${file.fileSize}", 
                        fileUrl: "${file.fileUrl}" 
                    }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            console.log("기존 파일 목록:", uploadedFiles); // 콘솔에 배열 출력
            updateFileList(); // 화면에 파일 목록 표시
        };
        
        // 파일 업로드 처리 함수
        function handleFileUpload() {
        	console.log(uploadedFiles);
            const fileInput = document.getElementById("fileUpload");
            const selectedFileName = document.getElementById("selectedFileName");
            const files = Array.from(fileInput.files); // 새로 선택된 파일들
            const allowedExtensions = /(\.txt|\.png|\.jpg|\.jpeg|\.gif|\.mp4|\.avi|\.mov)$/i;
            const maxSize = 10 * 1024 * 1024; // 최대 파일 크기 10MB
            const maxFiles = 5; // 최대 파일 개수

            for (const file of files) {
                // 파일 개수 초과 검사
                if (uploadedFiles.length >= maxFiles) {
                    alert(`최대 \${maxFiles}개의 파일만 업로드할 수 있습니다.`);
                    break;
                }

                // 파일 형식 검사
                if (!allowedExtensions.exec(file.name)) {
                    alert(`\${file.name}은(는) 허용되지 않는 파일 형식입니다.`);
                    continue;
                }

                // 파일 크기 검사
                if (file.size > maxSize) {
                    alert(`\${file.name}의 크기가 너무 큽니다. 최대 10MB까지 허용됩니다.`);
                    continue;
                }

                // 유효한 파일이면 배열에 추가
                uploadedFiles.push(file);
            }

            // 파일 목록 UI 업데이트
            updateFileList();

            // 파일 입력 초기화
            fileInput.value = "";
        }

        // 파일 목록 UI 업데이트 함수
        function updateFileList() {
            const fileListDiv = document.getElementById("fileList");
            fileListDiv.innerHTML = ""; // 기존 목록 초기화

            uploadedFiles.forEach((file, index) => {
                // 파일 이름 표시
                const fileItem = document.createElement("div");
                fileItem.classList.add("d-flex", "justify-content-between", "align-items-center", "p-2", "border", "rounded", "mb-2");

                const fileName = document.createElement("span");
                fileName.textContent = `\${file.name} (\${(file.size / 1024).toFixed(1)} KB)`; // 파일 이름과 크기 표시

                // 삭제 버튼
                const removeButton = document.createElement("button");
                removeButton.textContent = "삭제";
                removeButton.classList.add("btn", "btn-danger", "btn-sm");
                removeButton.onclick = () => {
                    uploadedFiles.splice(index, 1); // 배열에서 파일 제거
                    updateFileList(); // 목록 업데이트
                };

                fileItem.appendChild(fileName);
                fileItem.appendChild(removeButton);
                fileListDiv.appendChild(fileItem);
            });
        }
        
    </script>
</body>
</html>
