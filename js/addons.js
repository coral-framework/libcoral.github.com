$( function()
	{
		// automatically add the 'even' and 'odd' classes to table rows
		$('tbody > tr:nth-child(even)').addClass('even');
		$('tbody > tr:nth-child(odd)').addClass('odd');
	}
);
