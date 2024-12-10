package egovframework.LocalBoard.dto;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.web.multipart.MultipartFile;

public class SmarteditorVO {
	
	private MultipartFile filedata;
	private String callback;
	private String callback_func;

	public SmarteditorVO(MultipartFile filedata, String callback, String callback_func) {
		this.filedata = filedata;
		this.callback = callback;
		this.callback_func = callback_func;
	}

	public MultipartFile getFiledata() {
		return filedata;
	}

	public void setFiledata(MultipartFile filedata) {
		this.filedata = filedata;
	}

	public String getCallback() {
		return callback;
	}

	public void setCallback(String callback) {
		this.callback = callback;
	}

	public String getCallback_func() {
		return callback_func;
	}

	public void setCallback_func(String callback_func) {
		this.callback_func = callback_func;
	}

	@Override
	public String toString() {
		return "SmarteditorVO [filedata=" + filedata + ", callback=" + callback + ", callback_func=" + callback_func
				+ "]";
	}
	
}
