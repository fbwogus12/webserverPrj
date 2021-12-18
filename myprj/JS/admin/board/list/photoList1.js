window.addEventListener('DOMContentLoaded', function() {
	//메인으로 이동
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

	//수신자 아이디 클릭, 유저 정보 보기 및 메시지 보내기 엘리먼트
	var idClickDrop = document.getElementsByClassName('id_click');
	var idClickDropSwitch = new Array(idClickDrop.length);
	var userInfo = document.getElementsByClassName('items_user_info');
	var sendMsg = document.getElementsByClassName('items_send_message');

	//스위치값 세팅
	for (let i = 0; i < idClickDrop.length; i++)
		idClickDropSwitch[i] = false;
	//~스위치값 세팅 끝

	//아이디 클릭 시 이벤트, 유저 정보 보기 및 메시지 보내기
	for (let i = 0; i < idClickDrop.length; i++) {
		idClickDrop[i].addEventListener('click', function() {
			if (idClickDropSwitch[i] == false) {
				this.nextElementSibling.style.display = "block";
				idClickDropSwitch[i] = true;
				for (let j = 0; j < i; j++) {
					idClickDrop[j].nextElementSibling.style.display = "none";
					idClickDropSwitch[j] = false;
				}
				for (let j = i + 1; j < idClickDrop.length; j++) {
					idClickDrop[j].nextElementSibling.style.display = "none";
					idClickDropSwitch[j] = false;
				}
			} else {
				this.nextElementSibling.style.display = "none";
				idClickDropSwitch[i] = false;
			}
		});

		userInfo[i].addEventListener('click', function() {
			var user = this.parentElement.parentElement.children[0].textContent;
			location.href = '/member/userInfo?user=' + user;
		});

		sendMsg[i].addEventListener('click', function() {
			var user = this.parentElement.parentElement.children[0].textContent;
			var popupX = (window.innerWidth / 2);
			var popupY = (window.innerHeight / 2) - (558 / 2);
			window.open('/message/send?to=' + user, 'sendMsg', 'width=850,height=558,status=no,toolbar=no,scrollbars=no, left=' + popupX + ', top=' + popupY);
		});
	}
	//~아이디 클릭 시 이벤트, ~유저정보보기 및 메시지 보내기 끝
});