package entity;

public class Board {
	private long id;
	private String title;
	private String content;
	private String nickname;
	private String regdate;
	private String files;
	private int hit;
	private boolean urg;
	private boolean pub;
	private String writerId;
	private String writerIp;
	private int category;
	
	public Board() {}
	
	//nextBoard, prevBoard를 위한 생성자.
	public Board(long id, String title, boolean pub) {
		this.id = id;
		this.title = title;
		this.pub = pub;
	}
	
	public Board(String title, String nickname, String files, String content, boolean pub, boolean urg) {
		this.title = title;
		this.nickname = nickname;
		this.files = files;
		this.content = content;
		this.pub = pub;
		this.urg = urg;
	}
	
	public Board(long id, String title, String nickname, String regdate, int hit, String files, String content, boolean pub, boolean urg) {
		this.id = id;
		this.title = title;
		this.nickname = nickname;
		this.regdate = regdate;
		this.hit = hit;
		this.files = files;
		this.content = content;
		this.pub = pub;
		this.urg = urg;
	}
	
	//getBoard를 위한 생성자
	public Board(long id, String title, String nickname, String writer, String ip, String regdate, int hit, String files, String content, boolean pub, boolean urg) {
		this.id = id;
		this.title = title;
		this.nickname = nickname;
		this.writerId = writer;
		this.writerIp = ip;
		this.regdate = regdate;
		this.hit = hit;
		this.files = files;
		this.content = content;
		this.pub = pub;
		this.urg = urg;
	}
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getRegdate() {
		return regdate;
	}
	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	public String getFiles() {
		return files;
	}
	public void setFiles(String files) {
		this.files = files;
	}
	public int getHit() {
		return hit;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}
	public boolean isUrg() {
		return urg;
	}
	public void setUrg(boolean urg) {
		this.urg = urg;
	}
	public boolean isPub() {
		return pub;
	}
	public void setPub(boolean pub) {
		this.pub = pub;
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public String getWriterIp() {
		return writerIp;
	}
	public void setWriterIp(String writerIp) {
		this.writerIp = writerIp;
	}
	public int getCategory() {
		return category;
	}
	public void setCategory(int category) {
		this.category = category;
	}
	@Override
	public String toString() {
		return "board [id=" + id + ", title=" + title + ", content=" + content + ", nickname=" + nickname + ", regdate="
				+ regdate + ", files=" + files + ", hit=" + hit + ", urg=" + urg + ", pub=" + pub + ", writerId="
				+ writerId + ", writerIp=" + writerIp + ", category=" + category + "]";
	}
	
}
