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
	href="${pageContext.request.contextPath}css/board/main.css?ver=1.17">
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
	src="${pageContext.request.contextPath}js/board/main.js?ver=1.11"></script>
<title>메인 페이지</title>
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
		<footer> </footer>
	</div>
</body>

</html>