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
	href="${pageContext.request.contextPath}/css/board/boardDetailCSS/detail3.css?ver=1.00">
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
	src="${pageContext.request.contextPath}/js/board/boardDetailJS/detail3.js?ver=1.01"></script>

<title>영상게시판</title>
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
							<div class="partition"></div>
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
						<div class="board-detail">
							<h3 class="hidden">게시글 내용</h3>
							<table class="detail-table">
								<tbody>
									<tr class="">
										<th>제목</th>
										<td class="">${b.title}</td>
									</tr>
									<tr>
										<th>작성일</th>
										<td><fmt:parseDate value="${b.regdate }" var="dateFmt"
												pattern="yyyy-MM-dd HH:mm:ss" /> <fmt:formatDate
												value="${dateFmt }" pattern="yyyy-MM-dd HH:mm" /></td>
									</tr>
									<tr>
										<th>작성자</th>
										<td>${b.nickname}</td>
									</tr>
									<tr>
										<th>조회수</th>
										<td>${b.hit }</td>
									</tr>
									<tr class="content-style">
										<th>내용</th>
										<td><c:forTokens var="fileName" items="${b.files }"
												delims="," varStatus="st">
												<c:forTokens var="token" items="${fn:toLowerCase(fileName)}"
													delims="." varStatus="status">
													<c:if test="${status.last}">
														<c:choose>
															<c:when test="${token eq 'yt'}">
																<iframe id="player" class="slide_video" width="730"
																	height="410"
																	src="https://www.youtube.com/embed/${fn:split(fileName,'.')[0]}?enablejsapi=1&autoplay=0&mute=1&controls=1&loop=1&playlist=${fn:split(fileName,'.')[0]}"
																	frameborder="0"></iframe>
															</c:when>
														</c:choose>
													</c:if>
												</c:forTokens>
											</c:forTokens> <c:if test="${b.files ne null && b.files ne ''}">
												<hr />
											</c:if>${b.content }</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="deco-div"></div>
						<c:if test="${cbi.cmtPermit eq true}">
							<c:if test="${not empty sessionScope.validUser}">
								<div class="write_cmt">
									<div class="nick">
										<span>${sessionScope.validUser.getNickname()}</span>
									</div>
									<div class="content">
										<textarea class="cmt_txt" placeholder="여기에 댓글을 입력해주세요."></textarea>
									</div>
									<div class="submit_cmt" style="float: left;">
										<div>댓글 등록</div>
									</div>
								</div>
							</c:if>
							<c:if test="${empty sessionScope.validUser}">
								<a href="/login">댓글을 작성하려면 로그인이 필요합니다.</a>
							</c:if>
							<div class="partition1">
								<div id="cmtList">댓글 목록</div>
							</div>
							<div class="cmt">
								<ul>
									<c:forEach var="cmt" items="${cmt}">
										<li
											class="${cmt.del == false ? 'cmt_style' : 'del_cmt_style'}"><c:if
												test="${cmt.del == false}">
												<div style="display: none;">${cmt.id}</div>
												<div class="nick">
													<span>${cmt.nickname}</span>
												</div>
												<div class="content">
													<p class="txt">${cmt.content}</p>
													<textarea class="mod_content" style="display: none;"></textarea>
												</div>
												<div class="regdate">
													<fmt:parseDate value="${cmt.regdate }" var="dateFmt"
														pattern="yyyy-MM-dd HH:mm:ss" />
													<fmt:formatDate value="${dateFmt }"
														pattern="yy.MM.dd  HH:mm:ss" />
													<c:set var="user" value="${user}" />
													<c:if test="${user eq cmt.writerId}">
														<div>
															<button class="mod_btn btn_style3">수정</button>
															<button class="del_btn btn_style3">삭제</button>
															<button class="mod-reg_btn btn_style3"
																style="display: none">수정</button>
															<button class="cancle_btn btn_style3"
																style="display: none">취소</button>
														</div>
													</c:if>
													<c:if
														test="${user ne cmt.writerId && not empty sessionScope.validUser}">
														<div style="display: block;">
															<div class="report_cmt_box" style="display: none">
																<label style="font-weight: bolder; display: block;"><select
																	name="reasons" id="cmt_reasons" class="select_reason">
																		<option value="1">욕설</option>
																		<option value="2">광고</option>
																		<option value="3">괴롭힘</option>
																		<option value="4">부적절한 내용</option>
																		<option value="5">기타</option>
																</select> </label>
																<button class="report_cmt btn_style3" value="${cmt.id}">신고</button>
															</div>
															<button class="report_cmt_sub btn_style3">신고</button>
														</div>
													</c:if>
												</div>
											</c:if> <c:if test="${cmt.del == true }">
												<c:if test="${cmt.rCmt != null}">
													<div style="display: none">${cmt.id}</div>
													<div class="delCmt" style="margin-bottom: 12px;">삭제된
														댓글입니다.</div>
												</c:if>
											</c:if>
											<ul>
												<c:forEach var="rCmt" items="${cmt.rCmt}">
													<c:if test="${rCmt.del == false}">
														<c:if test="${cmt.id eq rCmt.cmtId }">
															<li
																class="${cmt.del == false ? 'rCmt_style' : 'orp_rCmt_style'}">
																<div style="display: none;">${rCmt.id}</div>
																<div class="rNick-div">
																	↳ <span>${rCmt.nickname}</span>
																</div>
																<div class="content">
																	<p class="txt">${rCmt.content}</p>
																	<textarea class="mod_content" style="display: none;"></textarea>
																</div>
																<div class="regdate">
																	<fmt:parseDate value="${rCmt.regdate }" var="dateFmt"
																		pattern="yyyy-MM-dd HH:mm:ss" />
																	<fmt:formatDate value="${dateFmt }"
																		pattern="yy.MM.dd  HH:mm:ss" />
																	<c:set var="user" value="${user}" />
																	<c:if test="${user eq rCmt.writerId}">
																		<div>
																			<button class="mod_btn btn_style3">수정</button>
																			<button class="del_btn btn_style3">삭제</button>
																			<button class="mod-reg_btn btn_style3"
																				style="display: none">수정</button>
																			<button class="cancle_btn btn_style3"
																				style="display: none">취소</button>
																		</div>
																	</c:if>
																	<c:if
																		test="${user ne rCmt.writerId && not empty sessionScope.validUser}">
																		<div style="display: block;">
																			<div class="report_reCmt_box" style="display: none">
																				<label style="font-weight: bolder; display: block;"><select
																					name="reasons" id="reCmt_reasons"
																					class="select_reason">
																						<option value="1">욕설</option>
																						<option value="2">광고</option>
																						<option value="3">괴롭힘</option>
																						<option value="4">부적절한 내용</option>
																						<option value="5">기타</option>
																				</select> </label> <span style="display: none">${rCmt.cmtId}</span>
																				<button class="report_reCmt btn_style3"
																					value="${rCmt.id}">신고</button>
																			</div>
																			<button class="report_reCmt_sub btn_style3">신고</button>
																		</div>
																	</c:if>
																</div>
															</li>
														</c:if>
													</c:if>
												</c:forEach>
											</ul> <c:if test="${not empty sessionScope.validUser}">
												<div class="write_reCmt" style="display: none">
													<div class="write_reCmt_nick">
														<div class="deco-div3"></div>
														<span
															style="font-weight: bolder; font-size: 20px; margin-left: 40px;">↳</span><span>${sessionScope.validUser.getNickname()}</span>
													</div>
													<div class="write_reCmt_txt">
														<textarea class="cmt_txt" placeholder="여기에 댓글을 입력해주세요."></textarea>
													</div>
													<div class="submit_reCmt">
														<div class="deco-div4"></div>
														<div>댓글 등록</div>
													</div>
												</div>
											</c:if></li>
									</c:forEach>
									<div class="page-content">
										<c:set var="page" value="${empty param.cp?1:param.cp}" />
										<c:set var="startNum" value="${page-(page-1)%10}" />
										<c:set var="lastNum"
											value="${fn:substringBefore(Math.ceil(cmtCount/10), '.') }" />
										<div class="before">
											<c:if test="${startNum>1 }">
												<a
													href="?board=${param.board}&cp=${startNum-10}&f=${param.f}&q=${param.q}&p=${param.p}"
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
														href="?id=${param.id}&board=${param.board}&cp=${startNum+idx}&f=${param.f }&q=${param.q}&p=${param.p}">${startNum+idx}</a>
												</c:if>
											</c:forEach>
										</div>
										<div class="next">
											<c:if test="${startNum+9 < lastNum }">
												<a
													href="?board=${param.board}&cp=${startNum+10}&f=${param.f }&q=${param.q}&p=${param.p}"
													class="btn btn-next">다음</a>
											</c:if>
											<c:if test="${startNum+9 >= lastNum}">
												<span class="btn btn-next" onclick="alert('다음 페이지가 없습니다.');">다음</span>
											</c:if>
										</div>
									</div>
								</ul>
							</div>
						</c:if>
						<div class="deco-div2"></div>
						<div class="back_to_list">
							<c:set var="user" value="${user}" />
							<c:if test="${user eq b.writerId}">
								<span class="btn_style_grey w80 del_board_btn"
									style="float: left; margin-left: 0;">삭제하기</span>
								<a class="btn_style_grey w80"
									href="/board/mod?board=${param.board}&id=${b.id }&p=${param.p}">수정하기</a>
							</c:if>
							<c:if
								test="${user ne b.writerId && not empty sessionScope.validUser}">
								<div class="report_box" style="display: none; float: left;">
									<label style="font-weight: bolder">신고 사유: <select
										name="reasons" id="reasons" class="select_reason">
											<option value="1" selected>욕설</option>
											<option value="2">광고</option>
											<option value="3">괴롭힘</option>
											<option value="4">부적절한 내용</option>
											<option value="5">기타</option>
									</select>
									</label>
									<button type="button" style="float: right; margin: 0 15px;"
										class="report btn_style_grey w160" value="${b.id}">이
										게시글을 신고</button>
								</div>
								<button type="button" style="float: left;"
									class="report_sub btn_style_grey w160">이 게시글을 신고</button>
							</c:if>
							<a class="btn_style_grey w160"
								href="/board/list?board=${param.board}&p=${param.p}&f=${param.f}&q=${param.q}">목록으로
								돌아가기</a>
						</div>
						<div class="move-container">
							<table class="move-table">
								<c:set var="next" value="${empty next?'null':next }" />
								<c:set var="prev" value="${empty prev?'null':prev }" />
								<tbody>
									<tr>
										<th>다음 글</th>
										<c:if test="${next == 'null' }">
											<td class="">다음 글이 없습니다.</td>
										</c:if>
										<c:if test="${next != 'null' }">
											<td class=""><a
												href="/board/detail?board=${param.board}&id=${next.id }&p=${param.p}&f=${param.f}&q=${param.q}">${next.title
                                                        }</a></td>
										</c:if>
									</tr>
									<tr>
										<th>이전 글</th>
										<c:if test="${prev == 'null' }">
											<td class="">이전 글이 없습니다.</td>
										</c:if>
										<c:if test="${prev != 'null' }">
											<td class=""><a
												href="/board/detail?board=${param.board}&id=${prev.id }&p=${param.p}&f=${param.f}&q=${param.q}">${prev.title
                                                        }</a></td>
										</c:if>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</main>
		<footer> </footer>
	</div>
</body>

</html>