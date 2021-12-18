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
	href="${pageContext.request.contextPath}/css/admin/board/adminBoardListCSS/normList1.css?ver=1.00">
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
	src="${pageContext.request.contextPath}/js/admin/board/adminBoardListJS/normList1.js?ver=1.03"></script>
<title>게시글 리스트 관리</title>
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
												placeholder="검색어" /> <input type="submit"
												class="btn_style3" value="검색" /><input type="hidden"
												name="board" value="${param.board}" /></td>
											<td>
												<div class="deco-div"></div>
											</td>
										</tr>
									</tbody>
								</table>
							</form>
						</div>
					</div>
					<form action="/admin/board/list?board=${param.board}" method="post">
						<legend>게시글 목록</legend>
						<div class="board-list">
							<table class="board-table">
								<caption class="blind">게시글 리스트 관리</caption>
								<thead class="board-list-head">
									<tr>
										<th scope="col" class="num_style th_style1">번호</th>
										<th scope="col" class="title_style th_style1">제목</th>
										<th scope="col" class="writer_style th_style1">작성자</th>
										<th scope="col" class="regdate_style th_style1">작성일</th>
										<th scope="col" class="hit_style th_style1">조회수</th>
										<th scope="col" class="pub_style th_style1"
											style="font-size: 12px;">공개</th>
										<th scope="col" class="del_style th_style1"
											style="font-size: 12px;">삭제</th>
										<th scope="col" class="urg_style th_style1"
											style="font-size: 12px;">강조</th>
									</tr>
								</thead>
								<tbody class="tbody_urgList">
									<c:forEach var="ul" items="${urgList}">
										<c:set var="open" value="" />
										<c:set var="urg" value="" />
										<%-- 기본은 빈 문자열--%>
										<c:if test="${ul.pub }">
											<%--pub==true인 리스트만 checked 값을 넣는다. --%>
											<c:set var="open" value="checked"></c:set>
										</c:if>
										<c:if test="${ul.urg }">
											<c:set var="urg" value="checked"></c:set>
										</c:if>
										<tr class="list_style1 urg_style2" style="position: relative;">
											<td class="num_style">${ul.id}</td>
											<td class="title_style"><a id="font_urg"
												href="/admin/board/detail?board=${param.board}&id=${ul.id}&p=${empty param.p?1:param.p}&f=${param.f}&q=${param.q}">${ul.title}</a>
												<span class="cmt_style1">${ul.cmtCount == 0?"":[ul.cmtCount]}</span>
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
											<td class="pub_style"><input type="checkbox"
												name="open_id" value="${ul.id }" ${open } value="true">
												<%--pub==true였으면 open에는 checked값이 들어 있으므로 체크됨.--%></td>
											<td class="del_style"><input type="checkbox"
												name="del_id" value="${ul.id}"></td>
											<td class="urg_style"><input type="checkbox"
												name="urg_id" value="${ul.id }" ${urg } value="true">
											</td>
										</tr>
									</c:forEach>
								</tbody>
								<tbody>
									<c:forEach var="b" items="${list}">
										<c:set var="open" value="" />
										<c:set var="urg" value="" />
										<%-- 기본은 빈 문자열--%>
										<c:if test="${b.pub }">
											<%--pub==true인 리스트만 checked 값을 넣는다. --%>
											<c:set var="open" value="checked"></c:set>
										</c:if>
										<c:if test="${b.urg }">
											<c:set var="urg" value="checked"></c:set>
										</c:if>
										<tr class="list_style1">
											<td class="num_style">${b.id}</td>
											<td class="title_style"><a
												href="/admin/board/detail?board=${param.board}&id=${b.id}&p=${empty param.p?1:param.p}&f=${param.f}&q=${param.q}">${b.title}</a>
												<span class="cmt_style1">${b.cmtCount == 0?""
                                                        :[b.cmtCount]}</span>
											</td>
											<td class="writer_style">${b.nickname}</td>
											<td class="regdate_style"><fmt:parseDate
													value="${b.regdate }" var="dateFmt"
													pattern="yyyy-MM-dd HH:mm:ss" /> <fmt:formatDate
													value="${dateFmt }" pattern="yyyy-MM-dd HH:mm" /></td>
											<td class="hit_style">${b.hit}</td>
											<td class="pub_style"><input type="checkbox"
												name="open_id" value="${b.id }" ${open } value="true">
												<%--pub==true였으면 open에는 checked값이 들어 있으므로 체크됨.--%></td>
											<td class="del_style"><input type="checkbox"
												name="del_id" value="${b.id}"></td>
											<td class="urg_style"><input type="checkbox"
												name="urg_id" value="${b.id }" ${urg } value="true">
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
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
						<div class="admin-button">
							<c:set var="ids" value="" />
							<c:forEach var="b" items="${listAll}">
								<c:set var="ids" value="${ids} ${b.id}" />
								<%-- 원래 ids값에 n.id를 추가하여 덧붙여서 컨트롤러에 전달해준다. 게시판의 모든 게시글 번호를 여기에 넣고, 
								del / pub / urg 관련하여 넘어오는 id 값들과 비교하여 DB값을 수정할 예정. 관리자에게는 안 보임.--%>
							</c:forEach>
							<input type="hidden" name="ids" value="${ids}"> <input
								type="submit" class="admin_btn" name="btn" value="공개하기">
							<input type="submit" class="admin_btn float_left" name="btn"
								value="삭제하기"> <input type="submit" class="admin_btn"
								name="btn" value="강조하기"> <a class="admin_btn"
								href="/admin/board/reg?board=${param.board}">글쓰기</a>
						</div>
					</form>
				</div>
			</div>
		</main>
		<footer> </footer>
	</div>
</body>

</html>