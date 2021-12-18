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
	href="${pageContext.request.contextPath}/css/admin/board/adminBoardDetailCSS/detail2.css?ver=1.19">
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
	src="${pageContext.request.contextPath}/js/admin/board/adminBoardDetailJS/detail2.js?ver=1.25"></script>

<title>상세 게시판 관리</title>
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
									<tr>
										<th>첨부파일</th>
										<td style="text-align: left;">
											<ul type="square">
												<c:forTokens var="fileName" items="${b.files }" delims=","
													varStatus="st">
													<c:if
														test="${fn:split(fn:toLowerCase(fileName),'.')[1] eq 'mp3' || fn:split(fn:toLowerCase(fileName),'.')[1] eq 'wav' ||  fn:split(fn:toLowerCase(fileName),'.')[1] eq 'flac' || fn:split(fn:toLowerCase(fileName),'.')[1] eq 'bmp'}">
														<li><a class="file_list"
															href="/board/download?file=${fileName}&board=${param.board}&regdate=<fmt:parseDate value="${b.regdate }" var="dateFmt"
														pattern="yyyy-MM-dd HH:mm:ss"/><fmt:formatDate
														value="${dateFmt }" pattern="yyyyMMdd" />">${fn:toLowerCase(fileName)}</a></li>
													</c:if>
												</c:forTokens>
											</ul>
										</td>
									</tr>
									<tr class="content-style">
										<th>내용</th>
										<td><c:forTokens var="fileName" items="${b.files }"
												delims="," varStatus="st">
												<c:forTokens var="token" items="${fn:toLowerCase(fileName)}"
													delims="." varStatus="status">
													<c:if test="${status.last}">
														<c:choose>
															<c:when
																test="${token eq 'mp3' || token eq 'wav' || token eq 'flac'}">
																<figure>
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
											</c:forTokens> <c:if test="${b.files ne null && b.files ne ''}">
												<hr />
											</c:if>${b.content }</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="deco-div"></div>
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
						<div class="partition1">
							<div id="cmtList">댓글 목록</div>
						</div>
						<div class="cmt">
							<ul>
								<c:forEach var="cmt" items="${cmt}">
									<li class="${cmt.del == false ? 'cmt_style' : 'del_cmt_style'}"><c:if
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
												<c:if test="${user ne cmt.writerId}">
													<div>
														<button class="admin_del_btn btn_style3">삭제</button>
													</div>
												</c:if>
											</div>
										</c:if> <c:if test="${cmt.del == true }">
											<div style="display: none;">${cmt.id}</div>
											<div class="nick">
												<span>${cmt.nickname}</span>
											</div>
											<div class="content">
												<p class="txt">${cmt.content}<span
														style="font-weight: bolder; color: blue">(삭제 요청된
														댓글)</span>
												</p>
												<textarea class="mod_content" style="display: none;"></textarea>
											</div>
											<div class="regdate">
												<fmt:parseDate value="${cmt.regdate }" var="dateFmt"
													pattern="yyyy-MM-dd HH:mm:ss" />
												<fmt:formatDate value="${dateFmt }"
													pattern="yy.MM.dd  HH:mm:ss" />
												<c:set var="user" value="${user}" />
												<div>
													<button class="admin_per_del_btn btn_style3">영구 삭제</button>
												</div>
											</div>
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
																<c:if test="${user ne rCmt.writerId}">
																	<div>
																		<button class="admin_del_btn btn_style3">삭제</button>
																	</div>
																</c:if>
															</div>
														</li>
													</c:if>
												</c:if>
												<c:if test="${rCmt.del == true}">
													<c:if test="${cmt.id eq rCmt.cmtId }">
														<li
															class="${cmt.del == false ? 'rCmt_style' : 'orp_rCmt_style'}">
															<div style="display: none;">${rCmt.id}</div>
															<div class="rNick-div">
																↳ <span>${rCmt.nickname}</span>
															</div>
															<div class="content">
																<p class="txt">${rCmt.content}<span
																		style="font-weight: bolder; color: blue">(삭제
																		요청된 댓글)</span>
																</p>
																<textarea class="mod_content" style="display: none;"></textarea>
															</div>
															<div class="regdate">
																<fmt:parseDate value="${rCmt.regdate }" var="dateFmt"
																	pattern="yyyy-MM-dd HH:mm:ss" />
																<fmt:formatDate value="${dateFmt }"
																	pattern="yy.MM.dd  HH:mm:ss" />
																<div>
																	<button class="admin_per_del_btn btn_style3">영구
																		삭제</button>
																</div>
															</div>
														</li>
													</c:if>
												</c:if>
											</c:forEach>
										</ul>
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
										</div></li>
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
						<div class="deco-div2"></div>
						<div class="back_to_list">
							<button class="btn_style_grey w80 admin_board_del_btn"
								style="float: left; margin-left: 0;">삭제하기</button>
							<c:if test="${b.pub == true}">
								<button class="btn_style_grey w80 admin_hide_btn"
									style="float: left; margin-left: 10px;">숨기기</button>
							</c:if>
							<c:if test="${b.pub == false}">
								<button class="btn_style_grey w80 admin_show_btn">게시하기</button>
							</c:if>
							<c:if test="${b.urg == false}">
								<button class="btn_style_grey w80 admin_urg_btn">강조하기</button>
							</c:if>
							<c:if test="${b.urg == true}">
								<button class="btn_style_grey w160 admin_del_urg_btn">
									강조 목록에서 제거</button>
							</c:if>
							<c:set var="user" value="${user}" />
							<c:if test="${user eq b.writerId}">
								<a class="btn_style_grey w80"
									href="/board/mod?board=${param.board}&id=${b.id }&p=${param.p}">수정하기</a>
							</c:if>
							<a class="btn_style_grey w160"
								href="/admin/board/list?board=${param.board}&p=${param.p}&f=${param.f}&q=${param.q}">목록으로
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
												href="/admin/board/detail?board=${param.board}&id=${next.id }&p=${param.p}&f=${param.f}&q=${param.q}">${next.title
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
												href="/admin/board/detail?board=${param.board}&id=${prev.id }&p=${param.p}&f=${param.f}&q=${param.q}">${prev.title
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