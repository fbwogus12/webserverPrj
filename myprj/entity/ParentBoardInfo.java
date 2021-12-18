package entity;

import java.util.List;

public class ParentBoardInfo {
	private int category;
	private String name;
	private int priority;
	private List<ChildBoardInfo> children;
	
	public ParentBoardInfo() {}

	public ParentBoardInfo(int category, String name, List<ChildBoardInfo> children) {
		super();
		this.category = category;
		this.name = name;
		this.children = children;
	}
	
	public int getCategory() {
		return category;
	}
	public void setCategory(int category) {
		this.category = category;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public List<ChildBoardInfo> getChildren() {
		return children;
	}
	public void setChildren(List<ChildBoardInfo> children) {
		this.children = children;
	}
	@Override
	public String toString() {
		return "ParentBoardInfo [category=" + category + ", name=" + name + ", children=" + children + "]";
	}
}
