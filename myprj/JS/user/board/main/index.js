window.addEventListener('DOMContentLoaded', function () {
	//메인으로 가기
	var directBtn = document.getElementsByClassName('direct_btn')[0];
	directBtn.addEventListener('click', function() {
		location.href = '/index';
	});
});