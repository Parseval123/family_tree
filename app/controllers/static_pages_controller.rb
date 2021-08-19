require "csv"

class StaticPagesController < ApplicationController
  def home
  end

  def shop
  
  end
  
  def contacts
  end
  
  def projects
	@varrub="ciao ciao"
  end
  
  def draw_tree_submit
  
	@fullname = params[:fullname]	
			
  end
  
  def draw_tree_render
  
  
	print(params[:fullname])
  
	table = CSV.parse(File.read("8566i1_9504225660cv5po3s1d11u_A.csv"), headers: true)

		found = table.find {|row| row['FullName'] == params[:fullname]} #=> returns first `row` that satisfies the block.

		#print(found.field("Father_ID"))
		#print(found.field("Mother_ID"))

		family_tree_structure = Array.new

		def printTree(name,name_id,table,depth,generation,family_tree_structure)
			if name=="" or name==nil or generation==0 
				return
			else
			
				found = table.find {|row| row['FullName'] == name and row['INDI_ID'] == name_id} #=> returns first `row` that satisfies the block.

				father = (found.field("Father"))
				father_ID = (found.field("Father_ID"))
				mother = (found.field("Mother"))
				mother_ID = (found.field("Mother_ID"))
				
				array_son_father = [father,name,'']
				array_son_mother = [mother,name,'']
				family_tree_structure.push(array_son_father)
				family_tree_structure.push(array_son_mother)

				
						for i in 0..depth
						print("-")
						end
						
					print(found.field("FullName")+"\n")	
					printTree(father,father_ID,table,depth+1,generation-1,family_tree_structure)
					#depth=depth-1
					printTree(mother,mother_ID,table,depth+1,generation-1,family_tree_structure)
				
			end
		end 

		name=found.field('FullName')
		name_id = table.find {|row| row['FullName'] == name}.field("INDI_ID")

		printTree(name,name_id,table,0,4,family_tree_structure)
		for item in family_tree_structure
		  print(item)
		  print("\n")
		end
		
		@final_family_tree = family_tree_structure
		logger.debug "#{family_tree_structure}"
		
		gon.your_array = @final_family_tree
  
  end
  
end
