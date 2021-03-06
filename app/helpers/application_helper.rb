module ApplicationHelper
	def full_title(page_title = '') # Method def, optional arg
		base_title = "CHISS D'AQUIN" # Variable assegnamento
		if page_title.empty? # Boolean test
			base_title # Implicit return
		else
			"#{page_title} | #{base_title}" # String interpolation
		end
	end
end
