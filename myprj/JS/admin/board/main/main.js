window.addEventListener('DOMContentLoaded', function() {
	//메인으로 가기
	var directBtn = document.getElementsByClassName('direct_btn')[0];
	directBtn.addEventListener('click', function() {
		location.href = '/main';
	});

	//세부 게시판 클릭 시, 버블 방지
	var aTags = document.querySelectorAll('.gnb a');
	var parentFunctions = document.querySelectorAll('.gnb .parent_function');
	for (let i = 0; i < aTags.length; i++) {
		aTags[i].addEventListener('click', function(event) {
			event.stopPropagation();
		});
	}
	//부모 게시판 기능 호버 시, 세부 게시판 호버 효과 방지
	for (let i = 0; i < parentFunctions.length; i++) {
		parentFunctions[i].addEventListener('mouseover', function(event) {
			this.nextElementSibling.nextElementSibling.style.display = 'none';
			event.stopPropagation();
		});
		parentFunctions[i].addEventListener('mouseout', function(event) {
			this.nextElementSibling.nextElementSibling.style.display = '';
			event.stopPropagation();
		});
	}

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
	//슬라이드 수정하기, functionName.children으로 찾아갈 수 있지만, 후에 가독성을 위해서 남겨둔다.
	var functionName = document.getElementsByClassName('function_name')[0];
	var selectFunction = document.getElementsByClassName('select_function')[0];


	var slideEditYt = document.getElementsByClassName('slide_edit_yt')[0];//유튜브 넣기 선택
	var slideEditImg = document.getElementsByClassName('slide_edit_img')[0];//이미지 넣기 선택
	var functionCancle = document.getElementsByClassName('function_cancle')[0];//선택 취소
	var ytEditBox = document.getElementsByClassName('yt')[0];//유튜브 넣기 선택 시, 유튜브 링크 입력창이 나와야 함.
	var imgEditBox = document.getElementsByClassName('img')[0];//이미지 넣기 선택 시, 이미지 업로드가 나와야 함.
	var slideYtEditCancle = document.getElementsByClassName('slide-yt-edit-no')[0];//유튜브 넣기 선택하고 나서 나오는 유튜브 링크 입력창의 취소
	var slideImgEditCancle = document.getElementsByClassName('slide-img-edit-no')[0];//이미니 젛기 선택하고 나서 나오는 이미지 업로드 창의 취소

	var slideImg = document.getElementsByName('upload_slide_img')[0];//이미지 업로드 시, 해당 이미지를 담고 있는 input
	var ytLink = document.getElementsByClassName('yt_input')[0];//유튜브 링크를 담아줄 input
	var extract = document.getElementsByClassName('extract')[0];//위의 input.value에서 고유 아이디값을 뽑아내는 버튼.

	var editImgExecute = document.getElementsByClassName('slide-img-edit-ok')[0];//최종  슬라이드 이미지 변경 확정.
	var editYtExecute = document.getElementsByClassName('slide-yt-edit-ok')[0];

	var selectors = document.getElementsByClassName('selectors');
	var selectNum = 0;
	var selectNumForEdit = document.getElementsByClassName('selector-num')[0];
	for (let i = 0; i < selectors.length; i++) {
		selectors[i].addEventListener('click', function() {
			selectNum = i;
			selectNumForEdit.textContent = i + 1;
		});
	}

	functionName.addEventListener('click', function() {
		selectFunction.style.display = 'block';
		ytEditBox.style.display = 'none';
		imgEditBox.style.display = 'none';
	});//i+1번째 슬라이드 수정 클릭 시 

	functionCancle.addEventListener('click', function() {
		selectFunction.style.display = 'none';
	});//i+1번째 슬라이드 수정 클릭 후, 취소

	slideEditYt.addEventListener('click', function() {
		selectFunction.style.display = 'none';
		imgEditBox.style.display = 'none';
		ytEditBox.style.display = 'block';
	});//유튜브 넣기 클릭

	slideYtEditCancle.addEventListener('click', function() {
		ytEditBox.style.display = 'none';
		var preview = document.getElementsByClassName('preview')[selectNum];
		var video = document.getElementsByClassName('slide_video')[selectNum];
		var slideItem = document.getElementsByClassName('slide_item')[selectNum];
		if (video != null)
			video.remove();
		preview.style.display = 'none';
		slideItem.style.display = 'block';
	});//유튜브 넣기 클릭 후, 취소

	slideImgEditCancle.addEventListener('click', function() {
		var preview = document.getElementsByClassName('preview')[selectNum];
		var img = document.getElementsByClassName('preview_img')[selectNum];
		if (img != null)
			img.remove();
		var slideItem = document.getElementsByClassName('slide_item')[selectNum];
		slideItem.style.display = 'block';
		imgEditBox.style.display = 'none';
		preview.style.display = 'none';
	});//이미지 넣기 클릭 후, 취소

	slideEditImg.addEventListener('click', function() {
		selectFunction.style.display = 'none';
		imgEditBox.style.display = 'block';
		ytEditBox.style.display = 'none';
	});//이미지 넣기 클릭

	slideImg.addEventListener('change', function() {
		var newImg = this.files[0];
		var slideItem = document.getElementsByClassName('slide_item')[selectNum];
		slideItem.style.display = 'none';
		var preview = document.getElementsByClassName('preview')[selectNum];
		preview.style.display = 'block';
		var img = document.createElement('img');
		img.setAttribute('src', URL.createObjectURL(newImg));
		img.className = 'preview_img';
		preview.append(img);
	});//이미지 미리보기

	var ytId;
	extract.addEventListener('click', function() {
		ytId = getYtId(ytLink.value); //입력된 유튜브 url에서 아이디 추출하기.
		if (ytId != false) {
			var frame = document.createElement('iframe');
			var preview = document.getElementsByClassName('preview')[selectNum];
			preview.style.display = 'block';
			var slideItem = document.getElementsByClassName('slide_item')[selectNum];
			slideItem.style.display = 'none';
			frame.setAttribute('id', 'player');
			frame.setAttribute('class', 'slide_video');
			frame.style.width = '896px';
			frame.style.height = '420px';
			frame.setAttribute('src', 'https://www.youtube.com/embed/' + ytId + '?enablejsapi=1&autoplay=0&mute=1&controls=1&loop=1&playlist=' + ytId)
			preview.append(frame);
			ytLink.value = '';
		} else
			ytId = null;
	});//유튜브 미리보기

	editImgExecute.addEventListener('click', function() {//이미지 변경 최종 확인
		var formData = new FormData();
		var newImg = slideImg.files[0];
		if (newImg !== null && newImg !== undefined) {
			formData.append('files', newImg);
			fileUpload = getXMLHttpRequest();
			fileUpload.open("POST", "/board/fileUpload", true);
			fileUpload.onreadystatechange = function() {
				if (fileUpload.readyState === 4) {
					if (fileUpload.status === 200) {
						var resultText1 = fileUpload.responseText;
						if (resultText1 != -1 && resultText1 != 0) {

							//새로운 이미지 등록
							httpRequest = getXMLHttpRequest();
							httpRequest.open('POST', '/admin/main/slide')
							httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');
							httpRequest.onreadystatechange = function() {
								if (httpRequest.readyState === 4) {
									if (httpRequest.status === 200) {
										var resultText2 = httpRequest.responseText;
										if (resultText2 != 0 && resultText2 != -1) {
											alert('변경되었습니다.');
											window.location.reload();
										} else if (resultText2 == 0)
											alert('올바른 파일 형식이 아닙니다.');
										else {
											alert('서버와의 통신 중 오류가 발생하였습니다.')
										}
									} else
										alert('서버와의 통신 중 오류가 발생하였습니다.');
								}
							};

							httpRequest.send('slideNum=' + selectNum + '&tmp=' + resultText1);
							//~게시글 등록 끝
						}
						else if (resultText1 == -1)
							alert('잘못된 파일 형식입니다.');
						else if (resultText1 == 0)
							alert('서버와의 통신이 실패하였습니다.');
						else
							alert('알 수 없는 오류가 발생하였습니다.');
					} else
						alert('서버와의 통신 중 오류가 발생하였습니다.');
				}
			};
			fileUpload.send(formData);
		} else
			alert('변경할 것을 선택하세요.');
	});

	editYtExecute.addEventListener('click', function() {//유튜브 변경 최종 확인
		if (ytId !== null && ytId !== undefined) {
			fileUpload = getXMLHttpRequest();
			fileUpload.open("GET", "/admin/main/slide?ytId=" + ytId + "&slideNum=" + selectNum, true);
			fileUpload.onreadystatechange = function() {
				if (fileUpload.readyState === 4) {
					if (fileUpload.status === 200) {
						var resultText1 = fileUpload.responseText;
						if (resultText1 != -1 && resultText1 != 0) {
							alert('변경되었습니다.');
							window.location.reload();
						}
						else if (resultText1 == -1)
							alert('잘못된 파일 형식입니다.');
						else if (resultText1 == 0)
							alert('서버와의 통신이 실패하였습니다.');
						else
							alert('알 수 없는 오류가 발생하였습니다.');
					} else
						alert('서버와의 통신 중 오류가 발생하였습니다.');
				}
			};
			fileUpload.send(null);
		} else
			alert('변경할 것을 선택하세요');
	});

	//부모 게시판 생성
	var createBoard = document.getElementsByClassName('create_board')[0];
	var makeParentBoard = document.getElementsByClassName('make_parent_board')[0];
	createBoard.addEventListener('click', function() {
		makeParentBoard.className = 'make_parent_board show1';
	});
	////게시판 생성 취소
	var makeCancle = document.getElementsByClassName('make_cancle')[0];
	makeCancle.addEventListener('click', function(event) {
		makeParentBoard.className = 'make_parent_board close1';
		event.stopPropagation()
	});
	////~게시판 생성 취소 끝
	////게시판 생성
	var makeConfirm = document.getElementsByClassName('make_confirm')[0];
	makeConfirm.addEventListener('click', function() {
		var name = document.getElementsByClassName('parent_board_name')[0].value;
		if (name.length > 8 || name == '' || name == undefined || name == null) {
			alert('부모 게시판 이름을 확인해주세요');
		} else {
			if (confirm(name + ' 게시판을 생성하시겠습니까?')) {
				httpRequest = getXMLHttpRequest();
				httpRequest.open("POST", "/admin/manage/board", true);
				httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
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
				httpRequest.send('name=' + name + '&type=mpb');
			}
		}
	});

	//~부모 게시판 생성 끝 

	//부모 게시판 클릭 시 이벤트
	var createChildBoard = document.getElementsByClassName('create-child-board')[0];
	var parentBoard = document.getElementsByClassName("parent");
	var parentBoardFunction = document.getElementsByClassName('parent_function');
	var parentFunctionSwitch = new Array(parentBoard.length);
	for (let i = 0; i < parentBoard.length; i++) {
		parentFunctionSwitch[i] = false;
		var showFunctions = function() {
			if (parentFunctionSwitch[i] == false) {
				parentBoardFunction[i].style.display = 'block';
				for (let j = 0; j < i; j++) {
					parentBoardFunction[j].style.display = 'none';
					parentFunctionSwitch[j] = false;
				}
				for (let k = i + 1; k < parentBoard.length; k++) {
					parentBoardFunction[k].style.display = 'none';
					parentFunctionSwitch[k] = false;
				}
				parentFunctionSwitch[i] = true;
			}
			else {
				parentBoardFunction[i].style.display = 'none';
				parentFunctionSwitch[i] = false;
			}
		}
		parentBoard[i].addEventListener('click', showFunctions);

		//자식 게시판 생성 클릭 시
		parentBoard[i].children[0].children[2].addEventListener('click', function(event) {
			var createChildBoardHeader = document.getElementsByClassName('parent-name')[0];
			createChildBoardHeader.innerHTML = parentBoard[i].children[1].textContent + '의 세부 게시판 생성';
			parentBoardFunction[i].style.display = 'none';
			parentFunctionSwitch[i] = false;
			document.getElementsByClassName('create-child-board-confirm')[0].value = this.value;
			createChildBoard.className = 'create-child-board show2';
			event.stopPropagation()
		});
		//세부 게시판 생성 클릭 시 끝

		//부모 게시판 이름 바꾸기 클릭 시
		parentBoard[i].children[0].children[0].addEventListener('click', function(event) {
			var orgPbName = this.parentElement.nextElementSibling.textContent;
			this.parentElement.nextElementSibling.textContent = '';
			this.parentElement.style.display = 'none';
			parentFunctionSwitch[i] = false;

			//기능창 숨기기
			parentBoard[i].children[0].style.visibility = 'hidden';
			parentBoard[i].children[0].style.zIndex = '-1';

			//새로운 이름 입력칸, 확인/취소 버튼 hover 시 자식 게시판이 나오는 걸 방지
			var childrenCategory = document.getElementsByClassName('children-category')[i];
			var hideChildrenCategory = function() {
				childrenCategory.style.display = 'none';
			};
			var visibleChildrenCategory = function() {
				childrenCategory.style.display = '';
			}
			this.parentElement.nextElementSibling.addEventListener('mouseover', hideChildrenCategory);
			this.parentElement.nextElementSibling.addEventListener('mouseout', visibleChildrenCategory);

			//새로운 이름을 입력받을 input 태그
			var newNameInput = document.createElement('input');
			newNameInput.type = 'text';
			newNameInput.style.width = '170px';
			newNameInput.maxLength = '8';
			newNameInput.className = 'new-pb-name';
			newNameInput.value = orgPbName;
			newNameInput.addEventListener('click', function(event) {
				event.stopPropagation()
			});
			//

			//확인, 취소 도구
			var newNameOk = document.createElement('button');
			newNameOk.value = this.value;
			newNameOk.textContent = '확인';
			newNameOk.className = 'new-name-ok btn-style3';
			newNameOk.addEventListener('click', function(event) {
				var newPbName = this.previousElementSibling.value;
				if (newPbName !== null && newPbName !== undefined && newPbName.length !== 0 && newPbName.length < 9) {
					if (confirm(newPbName + '으로 변경하시겠습니까?')) {
						httpRequest = getXMLHttpRequest();
						httpRequest.open("POST", "/admin/manage/board", true);
						httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
						httpRequest.onreadystatechange = function() {
							if (httpRequest.readyState === 4) {
								if (httpRequest.status === 200) {
									var resultText = httpRequest.responseText;
									if (resultText == 1) {
										alert('변경되었습니다.');
										window.location.reload();
									}
									else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
								} else alert('서버와의 통신 중 오류가 발생하였습니다.');
							}
						};
						httpRequest.send('newPbName=' + newPbName + '&type=pbName' + '&pbCategory=' + this.value);
					}
				} else
					alert('올바른 이름을 입력하세요');
				event.stopPropagation();
			});
			//

			var rollback = document.createElement('button');
			rollback.className = 'rollback btn-style3';
			rollback.textContent = '취소';
			rollback.addEventListener('click', function(event) {
				//원상복구	
				this.parentElement.removeEventListener('mouseover', hideChildrenCategory);
				this.parentElement.removeEventListener('mouseout', visibleChildrenCategory);
				this.parentElement.nextElementSibling.style.display = '';
				this.parentElement.previousElementSibling.style.display = '';
				this.parentElement.textContent = orgPbName;

				//기능창 숨겼던 거 다시 보여주기
				parentBoard[i].children[0].style.visibility = '';
				parentBoard[i].children[0].style.zIndex = '15';
				parentBoard[i].children[0].style.display = 'none';
				parentFunctionSwitch[i] = false;
				event.stopPropagation();
			});

			//생성한 태그들 붙이기
			this.parentElement.nextElementSibling.append(newNameInput);
			this.parentElement.nextElementSibling.append(newNameOk);
			this.parentElement.nextElementSibling.append(rollback);

			event.stopPropagation()
		});
		//부모 게시판 이름 바꾸기 클릭 시 끝

		//부모 게시판 삭제 클릭
		parentBoard[i].children[0].children[1].addEventListener('click', function(event) {
			var pbName = this.parentElement.nextElementSibling.textContent;//입력받은 부모 게시판 이름 
			if (confirm(pbName + '을 삭제하면 가지고 있는 자식 게시판도 모두 삭제됩니다. 삭제하시겠습니까?')) {
				var yes = prompt('y 혹은 yes를 입력해주세요', '');
				if (yes === 'y' || yes === 'yes') {
					httpRequest = getXMLHttpRequest();
					httpRequest.open("POST", "/admin/manage/board", true);
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
							} else alert('서버와의 통신 중 오류가 발생하였습니다.');
						}
					};
					httpRequest.send('&type=pbDelete' + '&pbCategory=' + this.value);
				}
			}
			event.stopPropagation()
		});
		//부모 게시판 삭제 끝

		//자식 게시판 관리 
		if (parentBoard[i].children[0].children[3] != undefined) {
			parentBoard[i].children[0].children[3].addEventListener('click', function(event) {
				var childrenCategory = parentBoard[i].children[2]
				var functionCount = childrenCategory.childElementCount; //children-category-function 개수
				//부모 기능창 숨기기
				this.parentElement.style.display = 'none';
				parentFunctionSwitch[i] = false;
				alert('기능창이 활성화되었습니다.');
				//자식 이름 변경, 삭제 버튼 보이기, 각 버튼 기능 추가하기
				for (let i = 0; i < functionCount; i++) {
					childrenCategory.children[i].children[1].style.display = 'inline-block';

					//자식 게시판 이름 변경 버튼
					childrenCategory.children[i].children[1].children[0].addEventListener('click', function(event) {
						var newCbName;
						while (true) {
							newCbName = prompt('자식 게시판의 새 이름을 지어주세요.', '');
							if (newCbName == null)
								break;
							else if (newCbName.length > 8 || newCbName.length == 0) {
								alert('8글자 이하로 지어주세요');
							} else
								break;
						}
						if (newCbName != null) {
							httpRequest = getXMLHttpRequest();
							httpRequest.open("POST", "/admin/manage/board", true);
							httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
							httpRequest.onreadystatechange = function() {
								if (httpRequest.readyState === 4) {
									if (httpRequest.status === 200) {
										var resultText = httpRequest.responseText;
										if (resultText == 1) {
											alert('변경되었습니다.');
											window.location.reload();
										}
										else if (resultText == 0) alert('서버와의 통신이 실패하였습니다.');
									} else alert('서버와의 통신 중 오류가 발생하였습니다.');
								}
							};
							httpRequest.send('newCbName=' + newCbName + '&type=cbName' + '&cbCategory=' + this.value);
						}
						event.stopPropagation()
					});

					//자식 게시판 삭제 버튼
					childrenCategory.children[i].children[1].children[1].addEventListener('click', function(event) {
						var cbName = this.parentElement.previousElementSibling.textContent;
						if (confirm(cbName + '을 삭제하면 해당 게시판의 모든 게시글도 삭제됩니다. 삭제하시겠습니까?')) {
							var yes = prompt('y 혹은 yes를 입력해주세요', '');
							if (yes === 'y' || yes === 'yes') {
								httpRequest = getXMLHttpRequest();
								httpRequest.open("POST", "/admin/manage/board", true);
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
										} else alert('서버와의 통신 중 오류가 발생하였습니다.');
									}
								};
								httpRequest.send('&type=cbDelete' + '&cbCategory=' + this.value);
							}
						}
					});
				}
				event.stopPropagation()
			});
		}
	}

	//자식(세부) 게시판 생성
	////자식 세부 게시판 생성 취소
	var createChildBoardCancle = document.getElementsByClassName('create-child-board-cancle')[0];
	createChildBoardCancle.addEventListener('click', function() {
		createChildBoard.className = 'create-child-board close2';
		document.getElementsByClassName('create-child-board-confirm')[0].value = '';
	});
	////끝
	////자식 세부 게시판 생성 ok
	var createChildBoardConfirm = document.getElementsByClassName('create-child-board-confirm')[0];
	createChildBoardConfirm.addEventListener('click', function() {
		var childBoardName = document.getElementsByClassName('child-board-name')[0].value;
		if (childBoardName.length > 8 || childBoardName == null || childBoardName == undefined || childBoardName === '')
			alert('자식 게시판 이름을 확인해주세요');
		else {
			var kind = document.querySelector('input[name="kind"]:checked').value;
			var regPermit = document.querySelector('input[name="reg-permit"]:checked').value;
			var cmtPermit = document.querySelector('input[name="cmt-permit"]:checked').value;
			var readPermit = document.querySelector('input[name="read-permit"]:checked').value;
			var pc = this.value;
			if (confirm(childBoardName + '으로 자식 게시판을 생성하시겠습니까?')) {
				httpRequest = getXMLHttpRequest();
				httpRequest.open("POST", "/admin/manage/board", true);
				httpRequest.setRequestHeader('content-Type', 'application/x-www-form-urlencoded');//변경 사항
				httpRequest.onreadystatechange = function() {
					if (httpRequest.readyState === 4) {
						if (httpRequest.status === 200) {
							var resultText = httpRequest.responseText;
							if (resultText == 1) {
								alert('정상 등록되었습니다.');
								window.location.reload();
							} else if (resultText == 0) 
								alert('서버와의 통신이 실패하였습니다.');
							else if(resultText == -1)
								alert('이미 동일한 이름의 게시판이 존재합니다.')
						} else alert('서버와의 통신 중 오류가 발생하였습니다.');
					}
				};
				httpRequest.send('cbn=' + childBoardName + '&type=mcb' + '&kind=' + kind + '&regPermit=' + regPermit + '&cmtPermit=' + cmtPermit + '&readPermit=' + readPermit + '&pc=' + pc);
			}
		}
	});
});

function getXMLHttpRequest() { //브라우저가 IE일 경우 XMLHttpRequest 객체 구하기 
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


//유튜브 url에서 id 추출.
function getYtId(ytLink) {
	if (ytLink === '' || ytLink === null || ytLink === undefined) {
		alert('URL를 확인해주세요');
		return false;
	}

	//반드시 http를 포함해야 한다. 
	if (ytLink.indexOf('http') == -1) {
		alert('URL을 확인해주세요');
		return false;
	}

	var ytId;
	if (ytLink.indexOf('?v=') != -1) {
		var parsedLink = ytLink.split('v=')[1];
		var endIndex = parsedLink.indexOf('&');
		var ytId;
		if (endIndex != -1) {
			ytId = parsedLink.substring(0, endIndex);
		}
		if (ytId === undefined || ytId === null) {
			alert('URL을 확인해주세요');
			return false;
		} else {
			return ytId;
		}
	} else {
		ytId = ytLink.split('/');
		if (ytId === undefined || ytId === null) {
			alert('URL을 확인해주세요');
			return false;
		}
		return ytId[3];
	}
};