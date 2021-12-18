<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="keywords" content="">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/board/boardModCSS/mod2.css?ver=1.01">
<title>게시글 수정</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-wEmeIV1mKuiNpC+IOBjI7aAzPcEZeedi5yW5f2yOq55WWLwNGmvvx4Um1vskeMj0"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-p34f1UUtsS3wqzfto5wAAmdvj+osOnFyQFpp4Ua3gs/ZVWx6oOypYoCJhGGScy+8"
	crossorigin="anonymous"></script>
<script type="text/javascript">
	var errMsg = "<c:out value='${errMsg}'/>";

	if (errMsg !== "") {
		alert(errMsg);
		window.history.back();
	}
</script>
<script
	src="${pageContext.request.contextPath}/js/board/boardModJS/mod2.js?ver=1.01"></script>
</head>

<body>
	<div id="wrap">
		<header>
			<div class="head-line">
				<div class="header-board">
					<img src="/upload/main/${mainImg}" class="title_img">
				</div>
			</div>
			<div class="gnb">
				<ul>
					<li class="direct"><button class="direct_btn">바로가기</button> <c:forEach
							var="pb" items="${pb}">
							<li class="parent">
								<button class="drop_btn">${pb.name}</button>
								<div class="children-category">
									<c:forEach var="cb" items="${pb.children}">
										<a href="/board/list?board=${cb.category}">${cb.name}</a>
									</c:forEach>
								</div>
							</li>
						</c:forEach>
				</ul>
			</div>
		</header>
		<!-- 로그인 정보 및 기타 안내 사항은 lnb에 몰아넣음. -->
		<main>
			<div class="lnb">
				<div class="user-wrapper">
					<div id="user-container">
						<div class="log-msg">
							<img src="">
							<p>안녕하세요</p>
							<p>${sessionScope.validUser.getNickname()}님</p>
							<p>반갑습니다.</p>
							<div id="log-middle">
								<p>
									<a href="">내 정보 보기</a>
								</p>
								<p>
									<a href="">작성한 글 보기</a>
								</p>
								<p>
									<a href="/message/sendList">내 메시지함 보기</a>
								</p>
							</div>
						</div>
						<div class="partition"></div>
						<div class="log-footer">
							<span><a href="/logout" class="footer_btn btn_style2">로그아웃</a></span>
							<span><a href="/checkBeforeModify"
								class="footer_btn2 btn_style2">개인 정보 수정</a></span>
						</div>
					</div>
				</div>
			</div>
			<div class="main-content">
				<div class="main-container">
					<div class="main-header">
						<div class="header-name">
							<h1>
								<a href="/board/list?board=${param.board}">${cbi.name}</a>
							</h1>
						</div>
						<fieldset>
							<form method="post" action="/board/mod"
								enctype="multipart/form-data">
								<div class="board-reg">
									<h3 class="hidden">게시글 수정</h3>
									<table class="reg-table">
										<tbody>
											<tr class="">
												<th>제목</th>
												<td><input type="text" name="title" class="title_style"
													placeholder="제목 입력" id="input_title" value="${b.title }"></td>
											</tr>
											<tr>
												<th>첨부파일</th>
												<td><div class="media_div">
														<span class="file_upload">파일업로드</span>
													</div>
													<div id="existing_files">
														<c:forTokens var="fileName" items="${b.files }" delims=","
															varStatus="st">
															<p>
																<span>${fileName}</span><span class="del_from_org_file"
																	id="del_${fileName}"> ⓧ</span>
															</p>
														</c:forTokens>
													</div>
													<div class="file_controller"></div></td>
											</tr>
											<tr>
												<th>작성자</th>
												<td>${b.nickname}</td>
											</tr>
											<tr class="content-style">
												<th>내용</th>
												<td class="text_td">
													<div class="org_preview">
														<c:forTokens var="fileName" items="${b.files }" delims=","
															varStatus="st">
															<c:forTokens var="token"
																items="${fn:toLowerCase(fileName)}" delims="."
																varStatus="status">
																<c:if test="${status.last}">
																	<c:choose>
																		<c:when
																			test="${token eq 'mp3' || token eq 'wav' || token eq 'flac'}">
																			<figure class="del_${fileName}">
																				<span style="float: left; font-weight: bolder;"
																					class="del_preview">ⓧ</span>
																				<audio controls
																					src="/upload/board/${cbi.name}/<fmt:parseDate value="${b.regdate }" var="dateFmt"
												pattern="yyyy-MM-dd HH:mm:ss" /><fmt:formatDate
												value="${dateFmt }" pattern="yyyyMMdd" />/${fileName}"></audio>
																				<figcaption style="font-weight: bolder;">
																					-${fileName}</figcaption>
																			</figure>
																		</c:when>
																	</c:choose>
																</c:if>
															</c:forTokens>
														</c:forTokens>
														<c:if test="${not empty b.files}">
															<hr />
														</c:if>
													</div>
													<div class="preview"></div> <textarea name="content"
														id="content_area" placeholder="내용 입력">${b.content }</textarea>
												</td>
											</tr>
										</tbody>
									</table>
									<div class="reg-footer">
										<div class="deco-div2"></div>
										<input type="hidden" id="board_id" name="board_id"
											value="${b.id}" />
										<button type="button" id="cancle_btn" onclick="cancle();"
											class="reg_style1">취소</button>
										<button type="button" value="수정" id="submit_btn"
											class="reg_style1">수정</button>
										<div class="hidden">
											<input type="text" id="files_to_server"
												name="files_to_server" />
											<div class="input_container"></div>
											<input type="hidden" name="org_del_files" id="org_del_files" />
											<span id="board_regdate"><fmt:parseDate
													value="${b.regdate }" var="dateFmt"
													pattern="yyyy-MM-dd HH:mm:ss" /> <fmt:formatDate
													value="${dateFmt }" pattern="yyyyMMdd" /></span>
										</div>
									</div>
								</div>
							</form>
						</fieldset>
					</div>
				</div>
			</div>
		</main>
		<footer> </footer>

	</div>
</body>

</html>