rows = document.getElementsByTagName("tr")
for (i = 0; i < rows.length; i++) {
	row = rows[i]
	if (row.cells[0].tagName == 'TD') {
		if (row.cells[0].childNodes[1].checked) 
			row.setAttribute("style", "background-color: #bfb;")
		else
			row.removeAttribute("style")
	}
}
