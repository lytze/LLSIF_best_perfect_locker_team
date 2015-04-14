cardListRowClick = function(row) {
	if (row.cells[0].childNodes[1].checked) {
		row.cells[0].childNodes[1].checked = false
	}
	else {
		row.cells[0].childNodes[1].checked = true
	}

	if (row.cells[0].childNodes[1].checked) 
		row.setAttribute("style", "background-color: #bfb; text-shadow: 0px 0px 7px #777")
	else
		row.removeAttribute("style")
	$(row.cells[0].childNodes[1]).trigger("change")
}