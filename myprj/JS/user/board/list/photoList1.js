window.addEventListener('DOMContentLoaded', function() {
	//메인으로 이동
	var directBtn = document.getElementsByClassName('direct_btn')[0];
	directBtn.addEventListener('click', function() {
		location.href = '/main';
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