<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="keywords" content="">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/board/boardRegCSS/reg2.css?ver=1.00">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-wEmeIV1mKuiNpC+IOBjI7aAzPcEZeedi5yW5f2yOq55WWLwNGmvvx4Um1vskeMj0"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-p34f1UUtsS3wqzfto5wAAmdvj+osOnFyQFpp4Ua3gs/ZVWx6oOypYoCJhGGScy+8"
	crossorigin="anonymous"></script>
<script
	src="${pageContext.request.contextPath}/js/board/boardRegJS/reg2.js?ver=1.00"></script>
<title>게시글 등록</title>
<script type="text/javascript">
	var errMsg = "<c:out value='${errMsg}'/>";

	if (errMsg !== "") {
		alert(errMsg);
		window.history.back();
	}
</script>
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
					<li class="direct"><button class="direct_btn">바로가기</button>
					<li class="notice">
						<button class="drop_btn notice_btn">공지사항</button>
						<div class="notice-category">
							<a href="/board/list?board=1">공지1</a> <a
								href="/board/list?board=11">공지2</a> <a
								href="/board/list?board=21">공지3</a> <a
								href="/board/list?board=31">공지4</a>
						</div>
					</li>
					<li class="board2">
						<button class="drop_btn board2_btn">자유게시판</button>
						<div class="board2-category">
							<a href="/board/reg?board=2">글쓰기</a>
						</div>
					</li>
					<li class="board3">
						<button class="drop_btn board3_btn">사진게시판</button>
						<div class="board3-category">
							<a href="/board/list?board=3">개인</a> <a
								href="/board/list?board=13">단체</a> <a
								href="/board/list?board=23">기타</a>
						</div>
					</li>
					<li class="board4">
						<button class="drop_btn board4_btn">동영상 게시판</button>
						<div class="board4-category">
							<a href="/board/list?board=4">동영상1</a> <a
								href="/board/list?board=14">동영상2</a> <a
								href="/board/list?board=24">동영상3</a>
						</div>
					</li>
					<li class="board5">
						<button class="drop_btn board5_btn">오디오 게시판</button>
						<div class="board5-category">
							<a href="/board/list?board=5">오디오1</a> <a
								href="/board/list?board=15">오디오2</a>
						</div>
					</li>
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
								<a href="/board/list?board=${param.board}">오디오 게시판</a>
							</h1>
						</div>
						<fieldset>
							<form>
								<div class="board2-reg">
									<h3 class="hidden">게시글 등록</h3>
									<table class="reg-table">
										<tbody>
											<tr class="">
												<th>제목</th>
												<td><input type="text" name="title" class="title_style"
													placeholder="제목 입력" id="input_title"></td>
											</tr>
											<tr>
												<th>첨부파일</th>
												<td><div class="media_div">
														<span class="file_upload">파일업로드</span>
													</div>
													<div class="file_controller"></div></td>
											</tr>
											<tr>
												<th>작성자</th>
												<td>${validUser.nickname }</td>
											</tr>
											<tr class="content-style">
												<th>내용</th>
												<td class="text_td">
													<div class="video_container"></div>
													<div class="preview"></div> <textarea name="content"
														id="content_area" placeholder="내용 입력"></textarea>
												</td>
											</tr>
										</tbody>
									</table>
									<div class="reg-footer">
										<div class="deco-div2"></div>
										<input type="hidden" value="${param.board}" name="board" />
										<button type="button" id="cancle_btn" onclick="cancle();"
											class="reg_style1">취소</button>
										<button type="button" value="등록" id="submit_btn"
											class="reg_style1">등록</button>
										<div class="hidden">
											<input type="text" id="files_to_server"
												name="files_to_server" />
											<div class="input_container"></div>
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