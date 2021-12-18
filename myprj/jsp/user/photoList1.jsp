<%@ page language="java" contentType="text/html; charset=utf-8"
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
	href="${pageContext.request.contextPath}/css/board/boardListCSS/photoList1.css?ver=1.03">
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
	src="${pageContext.request.contextPath}/js/board/boardListJS/photoList1.js?ver=1.01"></script>
<title>Ryu 사진게시판</title>
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
				<c:if test="${not empty sessionScope.validUser}">
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
							<div class="partition1"></div>
							<div class="log-footer">
								<span><a href="/logout" class="footer_btn btn_style2">로그아웃</a></span>
								<span><a href="/checkBeforeModify"
									class="footer_btn2 btn_style2">개인 정보 수정</a></span>
							</div>
						</div>
					</div>
				</c:if>
				<c:if test="${empty sessionScope.validUser}">
					<a href="/login">로그인 하러 가기</a>
				</c:if>
			</div>
			<div class="main-content">
				<div class="main-container">
					<div class="main-header">
						<div class="header-name">
							<h1>
								<a href="/board/list?board=${param.board}">${cbi.name}</a>
							</h1>
						</div>
						<div class="header-search">
							<form class="search_form">
								<table class="search_table">
									<tbody>
										<tr>
											<td>
												<div class="deco-div"></div>
											</td>
											<td class="td_style1"><span> <select name="f">
														<option ${(param.f=="title" )?"selected":"" }
															value="title">제목</option>
														<option ${(param.f=="content" )?"selected":"" }
															value="content">내용</option>
														<option ${(param.f=="writer" )?"selected":"" }
															value="writer">작성자</option>
												</select>
											</span></td>
											<td><label class="hidden">검색어</label> <input type="text"
												class="input_style3" name="q" value="${param.q}"
												placeholder="검색어" /> <input type="hidden" name="board"
												value="${param.board}" /> <input type="submit"
												class="btn_style3" value="검색" /></td>
											<td>
												<div class="deco-div"></div>
											</td>
										</tr>
									</tbody>
								</table>
							</form>
						</div>
					</div>
					<fieldset>
						<legend>사진게시판</legend>
						<div class="board-list">
							<table class="board-table">
								<caption class="blind">사진게시판</caption>
								<thead class="board-list-head">
									<tr>
										<th scope="col" class="num_style th_style1">번호</th>
										<th scope="col" class="title_style th_style1">제목</th>
										<th scope="col" class="writer_style th_style1">작성자</th>
										<th scope="col" class="regdate_style th_style1">작성일</th>
										<th scope="col" class="hit_style th_style1">조회수</th>
									</tr>
								</thead>
								<tbody class="tbody_urgList">
									<c:forEach var="ul" items="${urgList}">
										<tr class="list_style1 urg_style" style="position: relative;">
											<td class="num_style">${ul.id}</td>
											<td class="title_style"><a id="font_urg"
												href="/board/detail?board=${param.board}&id=${ul.id}&p=${empty param.p?1:param.p}&f=${param.f}&q=${param.q}">${ul.title}</a>
												<span class="cmt_style1">${ul.cmtCount == 0?"" :[ul.cmtCount]}</span>
											</td>
											<td class="writer_style"><span class="id_click"
												class="${ul.nickname == '관리자'?'red_point':''}">${ul.nickname}</span>
												<div class="id_drop_items">
													<div class="items_user_info">정보 보기</div>
													<div class="items_send_message">메시지 보내기</div>
												</div></td>
											<td class="regdate_style"><fmt:parseDate
													value="${ul.regdate }" var="dateFmt"
													pattern="yyyy-MM-dd HH:mm:ss" /> <fmt:formatDate
													value="${dateFmt }" pattern="yyyy-MM-dd HH:mm" /></td>
											<td class="hit_style">${ul.hit}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<div class="partition"></div>
							<div class="photo-container">
								<div class="photo-content">
									<c:forEach var="b" items="${list}">
										<div class="photo_style" style="position: relative;">
											<div class="img_style">
												<c:if test="${empty b.files}">
													<a
														href="/board/detail?board=${param.board}&id=${b.id}&p=${empty param.p?1:param.p}&f=${param.f}&q=${param.q}"><img
														class="img_style" src="" alt="파일이 없음. 삭제 요망"></a>
												</c:if>
												<c:forTokens var="fileName" items="${b.files }" delims=","
													varStatus="st">
													<c:if test="${st.first}">
														<a
															href="/board/detail?board=${param.board}&id=${b.id}&p=${empty param.p?1:param.p}&f=${param.f}&q=${param.q}"><img
															class="img_style"
															src="/upload/board/${cbi.name}/<fmt:parseDate value="${b.regdate }" var="dateFmt"
												pattern="yyyy-MM-dd HH:mm:ss" /><fmt:formatDate
												value="${dateFmt }" pattern="yyyyMMdd" />/${fileName}" alt="preview-img"></a>
													</c:if>
												</c:forTokens>
											</div>
											<span class="title_style"
												style="font-weight: bolder; display: block;">${b.title}<span
												class="cmt_style1">${b.cmtCount == 0?"" :[b.cmtCount]}</span></span>
											<div class="writer_style">
												작성자 : <span class="id_click">${b.nickname }</span>
												<div class="id_drop_items">
													<div class="items_user_info">정보 보기</div>
													<div class="items_send_message">메시지 보내기</div>
												</div>
											</div>
											<span class="regdate_style"><fmt:parseDate
													value="${b.regdate }" var="dateFmt"
													pattern="yyyy-MM-dd HH:mm:ss" /> <fmt:formatDate
													value="${dateFmt }" pattern="yyyy년 MM월 dd일" /></span> <span
												class="hit_style">조회수 : ${b.hit}</span>
										</div>
									</c:forEach>
								</div>
							</div>
							<c:if test="${not empty msg}">
								<span id="font_urg">내역이 없습니다.</span>
							</c:if>
						</div>

						<!-- 페이저  -->

						<div class="pager-container">
							<div class="page-content">
								<c:set var="page" value="${empty param.p?1:param.p}" />
								<c:set var="startNum" value="${page-(page-1)%10}" />
								<c:set var="lastNum"
									value="${fn:substringBefore(Math.ceil(count/10), '.') }" />

								<div class="">
									<h3 class="hidden">현재 페이지</h3>
									<div>
										<span class="total_page">/ <c:if
												test="${lastNum eq '0'}">1</c:if> <c:if
												test="${lastNum ne '0'}">${lastNum}</c:if>페이지
										</span> <span class="current_page">${empty param.p?1:param.p }</span>
									</div>
								</div>

								<div class="before">
									<c:if test="${startNum>1 }">
										<a
											href="?board=${param.board}&p=${startNum-10}&f=${param.f}&q=${param.q}"
											class="btn btn-next">이전</a>
									</c:if>
									<c:if test="${startNum<=1 }">
										<span class="btn btn-prev" onclick="alert('이전 페이지가 없습니다.');">이전</span>
									</c:if>
								</div>
								<div class="page-list">
									<c:forEach var="idx" begin="0" end="9">
										<c:if test="${(startNum+idx)<=lastNum }">
											<a class="page_style1 ${(page==(startNum+idx))?'red':''}"
												href="?board=${param.board}&p=${startNum+idx}&f=${param.f }&q=${param.q}">${startNum+idx}</a>
										</c:if>
									</c:forEach>
								</div>
								<div class="next">
									<c:if test="${startNum+9 < lastNum }">
										<a
											href="?board=${param.board}&p=${startNum+10}&f=${param.f }&q=${param.q}"
											class="btn btn-next">다음</a>
									</c:if>
									<c:if test="${startNum+9 >= lastNum}">
										<span class="btn btn-next" onclick="alert('다음 페이지가 없습니다.');">다음</span>
									</c:if>
								</div>
							</div>
						</div>
					</fieldset>
					<c:if test="${cbi.admin eq false}">
						<div class="btn">
							<a class="reg_btn" href="/board/reg?board=${param.board}">글쓰기</a>
						</div>
					</c:if>
				</div>
			</div>
		</main>
		<footer> </footer>
	</div>
</body>

</html>