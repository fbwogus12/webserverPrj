function check(event) {
	if (!confirm('게시글을 삭제하시겠습니까?'))
		event.preventDefault();
}

window.addEventListener('DOMContentLoaded', function() {
	var cmts = document.getElementsByClassName('cmt_style');
	var delCmts = document.getElementsByClassName('del_cmt_style');
	var rCmts = document.getElementsByClassName('rCmt_style');
	var orpRCmts = document.getElementsByClassName('orp_rCmt_style');
	var regCmt = document.getElementsByClassName('submit_cmt')[0];
	var regReCmts = document.getElementsByClassName('submit_reCmt');
	var modBtn = document.getElementsByClassName('mod_btn');
	var delBtn = document.getElementsByClassName('del_btn');
	var cancleBtn = document.getElementsByClassName('cancle_btn');
	var cmtTxt = document.getElementsByClassName('cmt_txt')[0];
	var params = new URLSearchParams(location.search)
	var boardId = params.get('id');
	var board = params.get("board");

	var directBtn = document.getElementsByClassName('direct_btn')[0];
	directBtn.addEventListener('click', function() {
		location.href = '/main';
	});

	//메인화면 헤더 사진 수정
	var reader = new FileReader();
	var titleImgUpload = document.getElementById('upload_file');
	var preview = document.getElementsByClassName('title_img')[0];
	var titleEditBtn = document.getElementsByClassName('title-img-edit')[0];
	var titleEditOk = document.getElementsByClassName('title-img-edit-ok')[0];
	var titleEditNo = document.getElementsByClassName('title-img-edit-no')[0];
	var orgImg;

	titleImgUpload.addEventListener('change', function(event) {
		orgImg = preview.src;
		titleEditOk.style.display = 'inline-block';
		titleEditNo.style.display = 'inline-block';
		titleEditBtn.style.display = 'none';
		reader.addEventListener('load', function(event) {
			preview.setAttribute('src', event.target.result);
		});
		reader.readAsDataURL(event.target.files[0]);
	});

	titleEditNo.addEventListener('click', function() {
		preview.src = orgImg;
		titleEditOk.style.display = 'none';
		titleEditNo.style.display = 'none';
		titleEditBtn.style.display = 'inline-block';
	});

	titleEditOk.addEventListener('click', function() {
		if (confirm('타이틀 이미지를 변경하시겠습니까?')) {
			var newImg = titleImgUpload.files[0];
			var formData = new FormData();
			formData.append('new_img', newImg);

			httpRequest = getXMLHttpRequest();
			httpRequest.open("POST", "/admin/main", true);
			//httpRequest.setRequestHeader('content-Type', 'multipart/form-data');//변경 사항
			httpRequest.onreadystatechange = function() {
				if (httpRequest.readyState === 4) {
					if (httpRequest.status === 200) {
						var resultText = httpRequest.responseText;
						if (resultText == 1) {
							alert('정상 등록되었습니다.');
							window.location.reload();
						}
						else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
					} else alert('서버와의 통신 중 오류가 발생하였습니다.');
				}
			};
			httpRequest.send(formData);
		} else alert('알 수 없는 오류 발생.');
	});

	//댓글 한 번 더 눌렀을 때, 댓글 입력창 닫기. 혹은 댓글, 대댓글 입력 창이 열려 있는지 확인할 때 사용할 수도 있음.
	//입력창이 켜진 상태 = true, 꺼진 상태 = false 
	var onoff = [];
	var onoff2 = [];
	for (let i = 0; i < cmts.length; i++) onoff[i] = false;
	for (let i = 0; i < cmts.length; i++) onoff2[i] = false;

	cmtTxt.addEventListener('keyup', function(e) {
		//엔터키 개행 막을 거면 여기에 적어놓자.
		/*
			if(e.keyCode == 13) {
				행위;
			}
		*/
		if (cmtTxt.value.length > 500) {
			alert('댓글 내용은 500자 이내로 작성해주세요.');
			let tmp = str.substr(0, 499);
			cmtTxt.value = tmp;
		}
	});
	//삭제된 댓글에 대한 대댓글 등록 이벤트
	for (let i = 0; i < orpRCmts.length; i++) {
		orpRCmts[i].children[2].addEventListener('click', function() {
			delIdx = getCmtIndex(orpRCmts[i].parentElement.parentElement, 'del_cmt_style'); //몇 번째 부모인지 확인.

			if (onoff2[delIdx] == false) {
				orpRCmts[i].parentElement.parentElement.children[5].style.display = 'block';
				for (let j = 0; j < delIdx; j++) {
					delCmts[j].children[5].style.display = 'none';
					onoff2[j] = false;
				}
				for (let k = delIdx + 1; k < delCmts.length; k++) {
					delCmts[k].children[5].style.display = 'none';
					onoff2[k] = false;
				}

				for (let o = 0; o < cmts.length; o++) {//일반 댓글에 열려 있는 댓글 입력창 전부 지워버림.
					cmts[o].children[5].style.display = 'none';
					onoff[o] = false;
				}

				onoff2[delIdx] = true;
			} else {
				orpRCmts[i].parentElement.parentElement.children[5].style.display = 'none';
				onoff2[delIdx] = false;
			}
		});
	}

	//일반적인 댓글에 대한 이벤트
	//각 댓글마다 클릭 시, 대댓글 입력 창 만들기, 한 댓글에 대댓글 입력창이 켜지면 나머지 대댓글 입력창은 전부 없어지도록. 
	for (let i = 0; i < cmts.length; i++) {
		cmts[i].children[2].addEventListener('click', function() {
			if (onoff[i] == false) {
				cmts[i].children[5].style.display = 'block';

				for (let di = 0; di < delCmts.length; di++) {//삭제된 부모 댓글들의 댓글 입력창을 모두 닫는다.
					delCmts[di].children[3].style.display = 'none';
					onoff2[di] = false;
				}

				for (let j = 0; j < i; j++) {
					cmts[j].children[5].style.display = 'none';
					onoff[j] = false;
				}
				for (let k = i + 1; k < cmts.length; k++) {
					cmts[k].children[5].style.display = 'none';
					onoff[k] = false;
				}
				onoff[i] = true;
			} else {
				cmts[i].children[5].style.display = 'none';
				onoff[i] = false;
			}
		});
	}
	//각 대댓글 클릭 시, 대댓글 입력창 만들기
	for (let i = 0; i < rCmts.length; i++) {
		rCmts[i].children[2].addEventListener('click', function() {
			var idx = getCmtIndex(rCmts[i].parentElement.parentElement, 'cmt_style');
			if (onoff[idx] == false) {
				rCmts[i].parentElement.parentElement.children[5].style.display = 'block';

				for (let di = 0; di < delCmts.length; di++) {//삭제된 부모 댓글들의 댓글 입력창을 모두 닫는다.
					delCmts[di].children[3].style.display = 'none';
					onoff2[di] = false;
				}

				for (let j = 0; j < idx; j++) {
					cmts[j].children[5].style.display = 'none';
					onoff[j] = false;
				}
				for (let k = idx + 1; k < cmts.length; k++) {
					cmts[k].children[5].style.display = 'none';
					onoff[k] = false;
				}
				onoff[idx] = true;
			} else {
				rCmts[i].parentElement.parentElement.children[5].style.display = 'none';
				onoff[idx] = false;
			}
		});
	}

	//댓글 등록 버튼을 눌렀을 때. 대댓글 등록 버튼을 다른 곳에서 진행한다.
	regCmt.addEventListener('click', function() {
		var httpRequest = null
		if (cmtTxt.value.length == 0) {
			cmtTxt.focus();
			alert('내용을 입력해주세요');
		} else {
			httpRequest = getXMLHttpRequest();
			httpRequest.open("POST", "/board/cmtReg", true);
			httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
			httpRequest.onreadystatechange = function() {
				if (httpRequest.readyState === 4) {
					if (httpRequest.status === 200) {
						var resultText = httpRequest.responseText;
						if (resultText == 1) {
							window.location.reload();
						}
						else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
						else alert(httpRequest.responseText + '는 금지된 단어입니다.');
					} else alert('서버와의 통신 중 오류가 발생하였습니다.');
				}
			};
			httpRequest.send("board=" + board + "&content=" + cmtTxt.value + "&boardId=" + boardId);
		}
	});

	//대댓글 등록 버튼에 전부 이벤트 리스너 달아주는 작업.
	for (let i = 0; i < regReCmts.length; i++) {
		regReCmts[i].addEventListener('click', function() {
			var httpRequest = null
			var cmtId = regReCmts[i].parentElement.parentElement.children[0].innerText
			var reCmtTxtBox = document.getElementsByClassName('write_reCmt_txt')[i];
			var reCmtTxt = reCmtTxtBox.children[0];
			if (reCmtTxt.value.length == 0) {
				reCmtTxt.focus();
				alert('내용을 입력해주세요');
			} else {
				httpRequest = getXMLHttpRequest();
				httpRequest.open("POST", "/board/cmtReg", true);
				httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
				httpRequest.onreadystatechange = function() {
					if (httpRequest.readyState === 4) {
						if (httpRequest.status === 200) {
							var resultText = httpRequest.responseText;
							if (resultText == 1) {
								window.location.reload();
							}
							else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
							else alert(httpRequest.responseText + '는 금지된 단어입니다.');
						} else alert('서버와의 통신 중 오류가 발생하였습니다.');
					}
				};
				httpRequest.send("board=" + board + "&content=" + reCmtTxt.value + "&boardId=" + boardId + "&cmtId=" + cmtId);
			}
		});
	}

	//수정 버튼 클릭 시, 삭제 대신 취소 버튼이 나오게 만들고 수정 버튼에 이벤트 달아주기.
	for (let i = 0; i < modBtn.length; i++) {
		modBtn[i].addEventListener('click', function() {
			let target = modBtn[i].parentElement.parentElement.parentElement.children[2];
			let before = target.children[0].textContent;
			target.children[1].value = before;
			target.children[1].style.display = 'block';
			target.children[0].style.display = 'none';
			modBtn[i].nextElementSibling.nextElementSibling.style.display = 'inline-block'; //최종 수정 버튼, 서버에 수정을 요청할 버튼
			modBtn[i].nextElementSibling.nextElementSibling.addEventListener('click', function() {
				var category = modBtn[i].parentElement.parentElement.parentElement.className;
				if (category == 'cmt_style') {
					var content = target.children[1].value;
					var cmtId = modBtn[i].parentElement.parentElement.parentElement.children[0].textContent
					httpRequest = getXMLHttpRequest();
					httpRequest.open("POST", "/board/cmtMod", true);
					httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
					httpRequest.onreadystatechange = function() {
						if (httpRequest.readyState === 4) {
							if (httpRequest.status === 200) {
								var resultText = httpRequest.responseText;
								if (resultText == 1) {
									alert('댓글이 수정되었습니다.');
									window.location.reload();
								}
								else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
								else alert(httpRequest.responseText + '는 금지된 단어입니다.');
							} else alert('서버와의 통신 중 오류가 발생하였습니다.');
						}
					};
					httpRequest.send("board=" + board + "&content=" + content + "&boardId=" + boardId + "&cmtId=" + cmtId);
				} else if (category = 'rCmt_style') {
					var content = target.children[1].value;
					var cmtId = modBtn[i].parentElement.parentElement.parentElement.parentElement.parentElement.children[0].textContent;
					var rCmtId = modBtn[i].parentElement.parentElement.parentElement.children[0].textContent
					httpRequest = getXMLHttpRequest();
					httpRequest.open("POST", "/board/cmtMod", true);
					httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
					httpRequest.onreadystatechange = function() {
						if (httpRequest.readyState === 4) {
							if (httpRequest.status === 200) {
								var resultText = httpRequest.responseText;
								if (resultText == 1) {
									alert('댓글이 수정되었습니다.');
									window.location.reload();
								}
								else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
								else alert(httpRequest.responseText + '는 금지된 단어입니다.');
							} else alert('서버와의 통신 중 오류가 발생하였습니다.');
						}
					};
					httpRequest.send("board=" + board + "&content=" + content + "&boardId=" + boardId + "&cmtId=" + cmtId + "&rCmtId=" + rCmtId);
				} else alert('알 수 없는 오류 발생.');
			});
			modBtn[i].nextElementSibling.nextElementSibling.nextElementSibling.style.display = 'inline-block'; //취소 버튼
			modBtn[i].nextElementSibling.style.display = 'none'; //삭제 버튼
			modBtn[i].style.display = 'none'; //일반 수정 버튼
		});
	}
	//삭제 버튼 
	for (let i = 0; i < delBtn.length; i++) {
		delBtn[i].addEventListener('click', function() {
			var category = delBtn[i].parentElement.parentElement.parentElement.className;
			if (category == 'cmt_style') {
				if (confirm("댓글을 삭제하시겠습니까?")) {
					var cmtId = delBtn[i].parentElement.parentElement.parentElement.children[0].textContent
					httpRequest = getXMLHttpRequest();
					httpRequest.open("POST", "/board/cmtDel", true);
					httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
					httpRequest.onreadystatechange = function() {
						if (httpRequest.readyState === 4) {
							if (httpRequest.status === 200) {
								var resultText = httpRequest.responseText;
								if (resultText == 1) {
									alert('삭제되었습니다.');
									window.location.reload();
								}
								else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
								else alert(httpRequest.responseText + '는 금지된 단어입니다.');
							} else alert('서버와의 통신 중 오류가 발생하였습니다.');
						}
					};
					httpRequest.send("board=" + board + "&boardId=" + boardId + "&cmtId=" + cmtId);
				}
			} else if (category = 'rCmt_style') {
				if (confirm('댓글을 삭제하시겠습니까?')) {
					var cmtId = delBtn[i].parentElement.parentElement.parentElement.parentElement.parentElement.children[0].textContent;
					var rCmtId = delBtn[i].parentElement.parentElement.parentElement.children[0].textContent
					httpRequest = getXMLHttpRequest();
					httpRequest.open("POST", "/board/cmtDel", true);
					httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
					httpRequest.onreadystatechange = function() {
						if (httpRequest.readyState === 4) {
							if (httpRequest.status === 200) {
								var resultText = httpRequest.responseText;
								if (resultText == 1) {
									alert('삭제되었습니다.');
									window.location.reload();
								}
								else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
								else alert(httpRequest.responseText + '는 금지된 단어입니다.');
							} else alert('서버와의 통신 중 오류가 발생하였습니다.');
						}
					};
					httpRequest.send("board=" + board + "&boardId=" + boardId + "&cmtId=" + cmtId + "&rCmtId=" + rCmtId);
				}
			} else alert('알 수 없는 오류 발생.');
		});
	}

	//수정 버튼 누르고, 마음이 바뀌어서 다시 취소 버튼을 누를 때.
	for (let i = 0; i < modBtn.length; i++) {
		cancleBtn[i].addEventListener('click', function() {
			let target = modBtn[i].parentElement.parentElement.parentElement.children[2];
			target.children[1].textContent = '';
			target.children[1].style.display = 'none';
			target.children[0].style.display = 'block';
			modBtn[i].nextElementSibling.nextElementSibling.style.display = 'none'; //최종 수정 버튼
			modBtn[i].nextElementSibling.nextElementSibling.nextElementSibling.style.display = 'none'; //취소 버튼
			modBtn[i].nextElementSibling.style.display = 'inline-block'; //삭제 버튼
			modBtn[i].style.display = 'inline-block'; //일반 수정 버튼
			for (let j = 0; j < i; j++) modBtn[j].parentElement.parentElement.parentElement.children[2].children[1].style.display = 'none';
			for (let k = i + 1; k < cmts.length; k++) modBtn[k].parentElement.parentElement.parentElement.children[2].children[1].style.display = 'none';
		});
	}


	//--------------------------여기부터는 관리자 전용----------------------------------

	var adminPerDelBtn = document.getElementsByClassName('admin_per_del_btn');
	var adminDelBtn = document.getElementsByClassName('admin_del_btn');

	//댓글, 대댓글 관리
	for (let i = 0; i < adminPerDelBtn.length; i++) {
		adminPerDelBtn[i].addEventListener('click', function() {
			var category = adminPerDelBtn[i].parentElement.parentElement.parentElement.className;
			if (category == 'del_cmt_style') {
				if (confirm("댓글을 영구 삭제하시겠습니까?")) {
					var cmtId = adminPerDelBtn[i].parentElement.parentElement.parentElement.children[0].textContent
					httpRequest = getXMLHttpRequest();
					httpRequest.open("POST", "/admin/board/detail", true);
					httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
					httpRequest.onreadystatechange = function() {
						if (httpRequest.readyState === 4) {
							if (httpRequest.status === 200) {
								var resultText = httpRequest.responseText;
								if (resultText == 1) {
									alert('삭제되었습니다.');
									window.location.reload();
								}
								else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
								else alert("알 수 없는 오류가 발생하였습니다.");
							} else alert('서버와의 통신 중 오류가 발생하였습니다.');
						}
					};
					httpRequest.send("board=" + board + "&boardId=" + boardId + "&cmtId=" + cmtId + "&task=2");
				}
			} else if (category = 'orp_rCmt_style') {
				if (confirm('댓글을 영구 삭제하시겠습니까?')) {
					var cmtId = adminPerDelBtn[i].parentElement.parentElement.parentElement.parentElement.parentElement.children[0].textContent;
					var rCmtId = adminPerDelBtn[i].parentElement.parentElement.parentElement.children[0].textContent
					httpRequest = getXMLHttpRequest();
					httpRequest.open("POST", "/admin/board/detail", true);
					httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
					httpRequest.onreadystatechange = function() {
						if (httpRequest.readyState === 4) {
							if (httpRequest.status === 200) {
								var resultText = httpRequest.responseText;
								if (resultText == 1) {
									alert('삭제되었습니다.');
									window.location.reload();
								}
								else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
								else alert('알 수 없는 오류가 발생하였습니다.');
							} else alert('서버와의 통신 중 오류가 발생하였습니다.');
						}
					};
					httpRequest.send("board=" + board + "&boardId=" + boardId + "&cmtId=" + cmtId + "&rCmtId=" + rCmtId + "&task=2");
				}
			} else alert('알 수 없는 오류 발생.');
		});
	}

	//관리자 권한으로 댓글 삭제하기
	for (let i = 0; i < adminDelBtn.length; i++) {
		adminDelBtn[i].addEventListener('click', function() {
			var category = adminDelBtn[i].parentElement.parentElement.parentElement.className;
			if (category == 'cmt_style') {
				if (confirm("관리자 권한으로 댓글을 삭제하시겠습니까?")) {
					var cmtId = adminDelBtn[i].parentElement.parentElement.parentElement.children[0].textContent
					httpRequest = getXMLHttpRequest();
					httpRequest.open("POST", "/admin/board/detail", true);
					httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
					httpRequest.onreadystatechange = function() {
						if (httpRequest.readyState === 4) {
							if (httpRequest.status === 200) {
								var resultText = httpRequest.responseText;
								if (resultText == 1) {
									alert('삭제되었습니다.');
									window.location.reload();
								}
								else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
								else alert("알 수 없는 오류가 발생하였습니다.");
							} else alert('서버와의 통신 중 오류가 발생하였습니다.');
						}
					};
					httpRequest.send("board=" + board + "&boardId=" + boardId + "&cmtId=" + cmtId + "&task=1");
				}
			} else if (category = 'rCmt_style') {
				if (confirm('관리자 권한으로 댓글을 삭제하시겠습니까?')) {
					var cmtId = adminDelBtn[i].parentElement.parentElement.parentElement.parentElement.parentElement.children[0].textContent;
					var rCmtId = adminDelBtn[i].parentElement.parentElement.parentElement.children[0].textContent
					httpRequest = getXMLHttpRequest();
					httpRequest.open("POST", "/admin/board/detail", true);
					httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
					httpRequest.onreadystatechange = function() {
						if (httpRequest.readyState === 4) {
							if (httpRequest.status === 200) {
								var resultText = httpRequest.responseText;
								if (resultText == 1) {
									alert('삭제되었습니다.');
									window.location.reload();
								}
								else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
								else alert('알 수 없는 오류가 발생하였습니다.');
							} else alert('서버와의 통신 중 오류가 발생하였습니다.');
						}
					};
					httpRequest.send("board=" + board + "&boardId=" + boardId + "&cmtId=" + cmtId + "&rCmtId=" + rCmtId + "&task=1");
				}
			} else alert('알 수 없는 오류 발생.');
		});
	}

	//게시글 관리
	var adminBoardDelBtn = document.getElementsByClassName('admin_board_del_btn')[0];
	var adminHiding = document.getElementsByClassName('admin_hide_btn')[0];
	var adminShow = document.getElementsByClassName('admin_show_btn')[0];
	var adminUrgBtn = document.getElementsByClassName('admin_urg_btn')[0];
	var adminDelUrgBtn = document.getElementsByClassName('admin_del_urg_btn')[0];
	var q = params.get('q');
	var f = params.get('f');
	var p = params.get('p');

	//게시글 삭제 버튼
	adminBoardDelBtn.addEventListener('click', function() {
		if (confirm('이 게시글을 삭제하시겠습니까?')) {
			httpRequest = getXMLHttpRequest();
			httpRequest.open("POST", "/admin/board/detail", true);
			httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
			httpRequest.onreadystatechange = function() {
				if (httpRequest.readyState === 4) {
					if (httpRequest.status === 200) {
						var resultText = httpRequest.responseText;
						if (resultText != 0) {
							alert('삭제되었습니다.');
							location.href = '/admin/board/list?board=' + board + '&q=' + q + '&f=' + f + '&p=' + p;
						}
						else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
						else alert("알 수 없는 오류가 발생하였습니다.");
					} else alert('서버와의 통신 중 오류가 발생하였습니다.');
				}
			};
			httpRequest.send("board=" + board + "&boardId=" + boardId + "&task=4");
		}
	});

	//게시물 숨김처리 버튼
	if (adminHiding != null) {
		adminHiding.addEventListener('click', function() {
			if (confirm('이 게시글을 숨김처리 하시겠습니까?')) {
				httpRequest = getXMLHttpRequest();
				httpRequest.open("POST", "/admin/board/detail", true);
				httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
				httpRequest.onreadystatechange = function() {
					if (httpRequest.readyState === 4) {
						if (httpRequest.status === 200) {
							var resultText = httpRequest.responseText;
							if (resultText == 1) {
								alert('숨김 처리되었습니다.');
								window.location.reload();
							}
							else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
							else alert("알 수 없는 오류가 발생하였습니다.");
						} else alert('서버와의 통신 중 오류가 발생하였습니다.');
					}
				};
				httpRequest.send("board=" + board + "&boardId=" + boardId + "&task=3&boardState=1&f=" + f + "&q=" + q + "&p=" + p);
			}
		});
	}

	//게시물 게시 버튼
	if (adminShow != null) {
		adminShow.addEventListener('click', function() {
			if (confirm('이 게시글을 게시하시겠습니까?')) {
				httpRequest = getXMLHttpRequest();
				httpRequest.open("POST", "/admin/board/detail", true);
				httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
				httpRequest.onreadystatechange = function() {
					if (httpRequest.readyState === 4) {
						if (httpRequest.status === 200) {
							var resultText = httpRequest.responseText;
							if (resultText == 1) {
								alert('게시되었습니다.');
								window.location.reload();
							}
							else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
							else alert("알 수 없는 오류가 발생하였습니다.");
						} else alert('서버와의 통신 중 오류가 발생하였습니다.');
					}
				};
				httpRequest.send("board=" + board + "&boardId=" + boardId + "&task=3&boardState=0&f=" + f + "&q=" + q + "&p=" + p);
			}
		});
	}

	//게시물 강조 버튼
	if (adminUrgBtn != null) {
		adminUrgBtn.addEventListener('click', function() {
			if (confirm('이 게시글을 게시판 강조 목록에 넣으시겠습니까?')) {
				httpRequest = getXMLHttpRequest();
				httpRequest.open("POST", "/admin/board/detail", true);
				httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
				httpRequest.onreadystatechange = function() {
					if (httpRequest.readyState === 4) {
						if (httpRequest.status === 200) {
							var resultText = httpRequest.responseText;
							if (resultText == 1) {
								alert('강조 처리되었습니다.');
								window.location.reload();
							}
							else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
							else alert("알 수 없는 오류가 발생하였습니다.");
						} else alert('서버와의 통신 중 오류가 발생하였습니다.');
					}
				};
				httpRequest.send("board=" + board + "&boardId=" + boardId + "&task=5&boardState=0&f=" + f + "&q=" + q + "&p=" + p);
			}
		});
	}

	//게시물 일반화 버튼
	if (adminDelUrgBtn != null) {
		adminDelUrgBtn.addEventListener('click', function() {
			if (confirm('이 게시글을 강조 목록에서 내리시겠습니까?')) {
				httpRequest = getXMLHttpRequest();
				httpRequest.open("POST", "/admin/board/detail", true);
				httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
				httpRequest.onreadystatechange = function() {
					if (httpRequest.readyState === 4) {
						if (httpRequest.status === 200) {
							var resultText = httpRequest.responseText;
							if (resultText == 1) {
								alert('게시글이 처리되었습니다.');
								window.location.reload();
							}
							else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
							else alert("알 수 없는 오류가 발생하였습니다.");
						} else alert('서버와의 통신 중 오류가 발생하였습니다.');
					}
				};
				httpRequest.send("board=" + board + "&boardId=" + boardId + "&task=5&boardState=1&f=" + f + "&q=" + q + "&p=" + p);
			}
		});
	}
});

function getXMLHttpRequest() { //브라우저가 IE일 경우 XMLHttpRequest 객체 구하기 
	var httpRequest = null;
	if (window.ActiveXObject) {
		//Msxml2.XMLHTTP가 신버전이어서 먼저 시도
		try {
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				return new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e1) {
				return null;
			}
		} //IE 외 파이어폭스 오페라 같은 브라우저에서 XMLHttpRequest 객체 구하기 
	} else if (window.XMLHttpRequest) {
		return new XMLHttpRequest();
	} else {
		return null;
	}
}


//대댓글 클릭 시, 해당 대댓글이 어떤 댓글에 대한 댓글인지 알 수 있도록 댓글의 idx를 가져옴.
function getCmtIndex(cmt, classNameOfCmt) {//cmt_style 혹은 del_cmt_style이 각각 몇 번째인지
	var idx = 0;
	var tmp;
	for (var i = 0; i < cmt.parentElement.children.length; i++) {
		if (cmt.parentElement.children[i].className === classNameOfCmt) {
			if (cmt.parentElement.children[i] === cmt) {
				tmp = idx;
			}
			idx++;
		}
	}
	return tmp;
}