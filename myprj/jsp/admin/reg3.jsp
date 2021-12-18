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
	href="${pageContext.request.contextPath}/css/admin/board/adminBoardRegCSS/reg3.css?ver=1.10">
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
	src="${pageContext.request.contextPath}/js/admin/board/adminBoardRegJS/reg3.js?ver=1.30"></script>
<script src="http://www.youtube.com/player_api"></script>
<script src=“https://www.youtube.com/iframe_api”></script>
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
					<img src="/upload/main/${mainImg}" class="title_img"> <label
						for="upload_file" class="title-img-edit">타이틀 사진 수정</label> <input
						id="upload_file" type="file" name="title_img"
						accept=".gif, .jpg, .jpeg, .png" style="display: none;">
					<button type="button" class="title-img-edit-ok">완료</button>
					<button type="button" class="title-img-edit-no">취소</button>
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
										<a href="/admin/board/list?board=${cb.category}">${cb.name}</a>
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
				<div class="nav-wrapper">
					<ul class="nav_style">
						<li class="admin_tab_header">관리자 전용</li>
						<li><a href="/admin/manage/log/userLog">로그 관리</a></li>
						<li><a href="/admin/manage/user/carefulUser">유의 사용자</a></li>
						<li><a href="/admin/manage/access">접근 관리</a></li>
						<li><a href="/admin/manage/userInfoList">사용자 목록</a></li>
						<li><a href="/admin/manage/report/board/list">신고 내역</a></li>
					</ul>
				</div>
			</div>

			<div class="main-content">
				<div class="main-container">
					<div class="main-header">
						<div class="header-name">
							<h1>
								<a href="/admin/board/list?board=${param.board}">${cbi.name}</a>
							</h1>
						</div>
						<fieldset>
							<form method="post" action="/admin/board/reg"
								enctype="multipart/form-data" id='reg-form'
								onsubmit='return regCheck(event);'>
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
												<th>유튜브 링크</th>
												<td><div class="media_div">
														<span class="yt_btn">유튜브 업로드</span> <span class="hidden"
															id="yt_option"> <input type="text" class="yt_link"
															name="yt_link" />
															<button type="button" class="link_reg_btn reg_style1">확인</button>
															<button type="button" class="link_reg_cancle reg_style1">취소</button>
														</span>
													</div>
													<div class="yt_controller"></div>
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
										<input type="hidden" value="${param.board}" name="board" /> <label
											class="check_style1">즉시 공개<input type="checkbox"
											name="pub" value="true" checked></label> <label
											class="check_style2">강조<input type="checkbox"
											name="urg" value="true"></label>
										<button type="button" id="cancle_btn" onclick="cancle();"
											class="reg_style1">취소</button>
										<button type="button" value="등록" id="submit_btn"
											class="reg_style1">등록</button>
										<input id="yt_input" type="hidden" name="yts"
											style="display: none;" />
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