<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="keywords" content="">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/board/main.css?ver=1.56">
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
	src="${pageContext.request.contextPath}/js/admin/board/main.js?ver=1.74"></script>
<title>관리자용 메인페이지</title>

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
							<li class="parent"><div class="parent_function">
									<button value="${pb.category}">부모 이름 바꾸기</button>
									<button value="${pb.category}">부모 게시판 삭제</button>
									<button class="make_child_board" value="${pb.category}">자식
										게시판 생성</button>
									<c:if test="${not empty pb.children}">
										<button>자식 게시판 관리</button>
									</c:if>
								</div>
								<button class="drop_btn">${pb.name}</button>
								<div class="children-category">
									<c:forEach var="cb" items="${pb.children}">
										<span> <a href="/admin/board/list?board=${cb.category}">${cb.name}</a>
											<span class="children-category-function">
												<button value="${cb.category}" class="btn-style3">변경</button>
												<button value="${cb.category}" class="btn-style3">삭제</button>
										</span>
										</span>
									</c:forEach>
								</div></li>
						</c:forEach>
				</ul>
			</div>
		</header>
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
				<div class="slide_function">
					<span class="function_name edit_style1"><span
						class="selector-num">1</span>번째 슬라이드 수정</span>
					<div class="select_function" style="display: none;">
						<p class="slide_edit_yt edit_style2">⊙유튜브 넣기</p>
						<p class="slide_edit_img edit_style2">⊙이미지 넣기</p>
						<p class="function_cancle btn_style5">취소</p>
					</div>
					<div class="yt" style="display: none;">
						<label class="yt_label">링크: <input type="text"
							name="slide_yt" class="yt_input" /></label><span class="extract">추출</span>
						<div class="yt_btn">
							<button type="button" class="slide-yt-edit-ok" value="${i}">변경</button>
							<button type="button" class="slide-yt-edit-no">취소</button>
						</div>
					</div>
					<div class="img" style="display: none;">
						<label for="upload_slide" class="upload_slide_img">이미지 업로드</label>
						<input id="upload_slide" type="file" name="upload_slide_img"
							accept=".gif, .jpg, .jpeg, .png" style="display: none;">
						<button type="button" class="slide-img-edit-ok" value="${i}">변경</button>
						<button type="button" class="slide-img-edit-no">취소</button>
					</div>
				</div>
				<div class="main-slider">
					<input type="radio" name="sel" id="sel1" checked> <input
						type="radio" name="sel" id="sel2"> <input type="radio"
						name="sel" id="sel3"> <input type="radio" name="sel"
						id="sel4"> <input type="radio" name="sel" id="sel5">
					<ul>
						<li>
							<div class="slide_item">
								<c:if test="${not empty slide1}">
									<c:forTokens var="token" items="${slide1.item}" delims="."
										varStatus="status">
										<c:choose>
											<c:when
												test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp' }">
												<figure class="img_box">
													<img src="/upload/main/${slide1.item}" alt="${slide1.item}" />
												</figure>
											</c:when>
											<c:when test="${token eq 'yt'}">
												<iframe id="player" class="slide_video" width="890"
													height="420"
													src="https://www.youtube.com/embed/${fn:split(slide1.item,'.')[0]}?enablejsapi=1&autoplay=0&mute=1&controls=1&loop=1&playlist=${fn:split(slide1.item,'.')[0]}"
													frameborder="0"></iframe>
											</c:when>
										</c:choose>
									</c:forTokens>
								</c:if>
							</div>
							<figure class="preview" style="display: none;"></figure>
						</li>
						<li>
							<div class="slide_item">
								<c:if test="${not empty slide2}">
									<c:forTokens var="token" items="${slide2.item}" delims="."
										varStatus="status">
										<c:choose>
											<c:when
												test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp' }">
												<figure class="img_box">
													<img src="/upload/main/${slide2.item}" alt="${slide2.item}" />
												</figure>
											</c:when>
											<c:when test="${token eq 'yt'}">
												<iframe id="player" class="slide_video" width="890"
													height="420"
													src="https://www.youtube.com/embed/${fn:split(slide2.item,'.')[0]}?enablejsapi=1&autoplay=0&mute=1&controls=1&loop=1&playlist=${fn:split(slide2.item,'.')[0]}"
													frameborder="0"></iframe>
											</c:when>
										</c:choose>
									</c:forTokens>
								</c:if>
							</div>
							<figure class="preview" style="display: none;"></figure>
						</li>
						<li>
							<div class="slide_item">
								<c:if test="${not empty slide3}">
									<c:forTokens var="token" items="${slide3.item}" delims="."
										varStatus="status">
										<c:choose>
											<c:when
												test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp' }">
												<figure class="img_box">
													<img src="/upload/main/${slide3.item}" alt="${slide3.item}" />
												</figure>
											</c:when>
											<c:when test="${token eq 'yt'}">
												<iframe id="player" class="slide_video" width="890"
													height="420"
													src="https://www.youtube.com/embed/${fn:split(slide3.item,'.')[0]}?enablejsapi=1&autoplay=0&mute=1&controls=1&loop=1&playlist=${fn:split(slide3.item,'.')[0]}"
													frameborder="0"></iframe>
											</c:when>
										</c:choose>
									</c:forTokens>
								</c:if>
							</div>
							<figure class="preview" style="display: none;"></figure>
						</li>
						<li>
							<div class="slide_item">
								<c:if test="${not empty slide4}">
									<c:forTokens var="token" items="${slide4.item}" delims="."
										varStatus="status">
										<c:choose>
											<c:when
												test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp' }">
												<figure class="img_box">
													<img src="/upload/main/${slide4.item}" alt="${slide4.item}" />
												</figure>
											</c:when>
											<c:when test="${token eq 'yt'}">
												<iframe id="player" class="slide_video" width="890"
													height="420"
													src="https://www.youtube.com/embed/${fn:split(slide4.item,'.')[0]}?enablejsapi=1&autoplay=0&mute=1&controls=1&loop=1&playlist=${fn:split(slide4.item,'.')[0]}"
													frameborder="0"></iframe>
											</c:when>
										</c:choose>
									</c:forTokens>
								</c:if>
							</div>
							<figure class="preview" style="display: none;"></figure>
						</li>
						<li>
							<div class="slide_item">
								<c:if test="${not empty slide5}">
									<c:forTokens var="token" items="${slide5.item}" delims="."
										varStatus="status">
										<c:choose>
											<c:when
												test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp' }">
												<figure class="img_box">
													<img src="/upload/main/${slide5.item}" alt="${slide5.item}" />
												</figure>
											</c:when>
											<c:when test="${token eq 'yt'}">
												<iframe id="player" class="slide_video" width="890"
													height="420"
													src="https://www.youtube.com/embed/${fn:split(slide5.item,'.')[0]}?enablejsapi=1&autoplay=0&mute=1&controls=1&loop=1&playlist=${fn:split(slide5.item,'.')[0]}"
													frameborder="0"></iframe>
											</c:when>
										</c:choose>
									</c:forTokens>
								</c:if>
							</div>
							<figure class="preview" style="display: none;"></figure>
						</li>
					</ul>
					<p class="selector">
						<label for="sel1" class="selectors">○</label> <label for="sel2"
							class="selectors">○</label> <label for="sel3" class="selectors">○</label>
						<label for="sel4" class="selectors">○</label> <label for="sel5"
							class="selectors">○</label>
					</p>
				</div>
				<div class="main-container">
					<c:forEach var="preBoard" items="${preBoard}">
						<div class="content">
							<h1>
								<a href="/board/list?board=${preBoard.child.category}">${preBoard.child.name}</a>
							</h1>
							<ul>
								<c:forEach var="post" items="${preBoard.previewList}">
									<li><a
										href="/board/detail?board=${preBoard.child.category}&id=${post.id}">⍟
											${post.title}</a> <span class="cmt_style1">${post.cmtCount == 0?"" :[post.cmtCount]}</span></li>
								</c:forEach>
							</ul>
						</div>
					</c:forEach>
				</div>
			</div>
		</main>
		<div class="create_board">
			+부모 게시판 만들기
			<div class="make_parent_board close1">
				<h3>부모 게시판 속성</h3>
				<label><span class="black_point">게시판 이름(8글자 미만):</span><input
					type="text" name="parent_board_name" class="parent_board_name"
					maxlength="8" /></label>
				<div class="btns">
					<button type="button" class="make_cancle">취소</button>
					<button type="button" class="make_confirm">생성</button>
				</div>
			</div>
		</div>
		<div class="create-child-board close2">
			<h2 class="parent-name">세부 게시판 생성</h2>
			<table>
				<tr>
					<th>세부 게시판 이름:</th>
					<td><input type="text" class="child-board-name" maxlength="8"
						placeholder="게시판 이름(8글자 이하)"></td>
				</tr>
				<tr>
					<th>세부 게시판 형식:</th>
					<td><label><input type="radio" name="kind" value="1"
							checked /><span>일반 게시판 - 파일 업로드(사진,영상,문서 파일 허용)</span></label></td>
				</tr>
				<tr>
					<th></th>
					<td><label><input type="radio" name="kind" value="2" /><span>일반
								게시판 - 파일 업로드(음성 파일만 허용)</span></label></td>
				</tr>
				<tr>
					<th></th>
					<td><label><input type="radio" name="kind" value="3" /><span>카드
								게시판 - 영상</span></label></td>
				</tr>
				<tr>
					<th></th>
					<td><label><input type="radio" name="kind" value="4" /><span>카드
								게시판 - 사진</span></label></td>
				</tr>
				<tr>
					<th>일반 사용자 글 작성:</th>
					<td><label><input type="radio" name="reg-permit"
							value="t" checked /><span>허용</span></label><label><input
							type="radio" name="reg-permit" value="f" /><span>비허용</span></label></td>
				</tr>
				<tr>
					<th>일반 사용자 댓글 작성:</th>
					<td><label><input type="radio" name="cmt-permit"
							value="t" checked /><span>허용</span></label><label><input
							type="radio" name="cmt-permit" value="f" /><span>비허용</span></label></td>
				</tr>
				<tr>
					<th>미로그인 사용자 읽기:</th>
					<td><label><input type="radio" name="read-permit"
							value="t" checked /><span>허용</span></label><label><input
							type="radio" name="read-permit" value="f" /><span>비허용</span></label></td>
				</tr>
			</table>
			<div class="create-child-board-btns">
				<button type="button" class="create-child-board-confirm">생성</button>
				<button type="button" class="create-child-board-cancle">취소</button>
			</div>
		</div>
		<footer> </footer>

	</div>
</body>

</html>