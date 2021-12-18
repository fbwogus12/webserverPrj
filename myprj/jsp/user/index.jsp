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
	href="${pageContext.request.contextPath}css/board/index.css?ver=1.08">
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
	src="${pageContext.request.contextPath}js/board/index.js?ver=1.12"></script>
<title>인덱스</title>
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
				<div class="login-wrapper">
					<div id="login-container">
						<fieldset>
							<legend>로그인</legend>
							<div id="login-box">
								<div class="login-btn">
									<a href="http://localhost:8080/login"><img
										src="${pageContext.request.contextPath}images/login.png"></a>
								</div>
								<ul class="login-menu">
									<li class="join"><a href="#"
										onClick="window.open('http://localhost:8080/join', '회원 가입','width=720, height= 600'); return false";>회원가입</a>
									</li>
									<li class="find"><a href="#"
										onClick="window.open('http://localhost:8080/findUserId', '아이디 찾기', 'width=700, height=380'); return false";>ID/PW찾기</a>
									</li>
								</ul>
							</div>
						</fieldset>
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