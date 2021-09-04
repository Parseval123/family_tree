require "csv"

class StaticPagesController < ApplicationController
  def home
  
	@posts = Post.all.sort_by(&:views)
	print(@posts)
	print("TEST #1 => "+@posts[0].to_s+"\n")
		print("TEST #2 => "+@posts[0].title+"\n")
			print("TEST #1 => "+@posts[0].body.to_s+"\n")
			
	print(@posts[0].body.to_s)
  
  end

  def shop
  
  end
  
  def contacts
  end
  
  def projects
  
	    @posts = Post.all
		@families = Array.new
		@posts.each do |post_s|
		
			#print(post_s.family_name.to_s+"\n")
			if (post_s.family==true)
				if not @families.include?(post_s.family_name.to_s)
					@families.push(post_s.family_name.to_s)
				end
			end
			
		end
		
		print(@families)
		#####################################################
		@couples = Hash.new
		@families = @families.sort
		
		@families.each do |family_soprannome|
			buff_post = Array.new
				@posts.each do |post|
					if (family_soprannome==post.family_name.to_s and post.family==true)
						buff_post.push(post)
					end
				end
			
			#sorting by id per mantenere omogeneo l'ordine degli elementi nel menu ad eccezione dell'albero che compare in top.
			buff_post = buff_post.sort_by{|obj| obj.id}
			
			#gestione albero come primo elemento del dropdown menu
			family_tree = buff_post.find {|e| e.title == "Albero Genealogico"}
			print("TEST FAMILY TREEE ===> "+family_tree.to_s)
			buff_post.delete(family_tree)
			
			print("################buffpost###################")
			print(buff_post)
			if not(family_tree==nil)
				#unshift porta in prima posizione l'elemente family tree ovvero il post dal titolo Albero Genealogico se esiste
				buff_post.unshift(family_tree)
			end
			print("################buffpost###################")

		@couples[family_soprannome] = buff_post
		print(@couples)
		
		end
		
  end
  
  def draw_tree_submit
  
	@fullname = params[:fullname]	
	
  end
  
  def draw_tree_render
  
  print("TEST FULLNAME "+params[:fullname].to_s)
    print("TEST GENERATION LENGTH "+params[:generation_length].to_s)
	  print("TEST INDI_ID "+params[:whatever].to_s)



		def printTree(name,name_id,table,depth,generation,family_tree_structure)
			if name=="" or name==nil or generation==0 
				return
			else
			
				found = table.find {|row| row['FullName'] == name and row['INDI_ID'] == name_id} #=> returns first `row` that satisfies the block.

				father = (found.field("Father"))
				father_ID = (found.field("Father_ID"))
				mother = (found.field("Mother"))
				mother_ID = (found.field("Mother_ID"))
				
				
				#per evitare duplicati
				name = name+" "+name_id
					
				if(father_ID==nil)
				father_ID=" "
				end
				if(mother_ID==nil)
				mother_ID=" "
				end
				if(father==nil)
				father_ID="N.P."
				end
				if(mother==nil)
				mother_ID="N.P."
				end
				
				#calcolo date n/m per tooltip
				
				found_F = table.find {|row| row['FullName'] == father and row['INDI_ID'] == father_ID} 
				found_M = table.find {|row| row['FullName'] == mother and row['INDI_ID'] == mother_ID} 
				if(found_F == nil or found_M == nil)
				birth_F = "";
				death_F = "";
				birth_M = "";
				death_M = "";
				else
				birth_F = found_F.field("Birth");
				death_F = found_F.field("Death");
				birth_M = found_M.field("Birth");
				death_M = found_M.field("Death");
				end
				array_son_father = [father.to_s+" "+father_ID,name,birth_F.to_s+" "+death_F.to_s]
				array_son_mother = [mother.to_s+" "+mother_ID,name,birth_M.to_s+" "+death_M.to_s]
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
		
	
	if (params[:fullname]==nil and params[:generation_length]==nil and params[:whatever]==nil)
		redirect_to controller: 'static_pages', action: 'draw_tree_submit'

	else
		print(params[:fullname])
		print(params[:generation_length])
		

	  
		table = CSV.parse(File.read("8566i1_9504225660cv5po3s1d11u_A.csv"), headers: true)
		
			#manage more than one hit
			
				found = table.select {|row| row['FullName'] == params[:fullname]}
				if found.length>1
				print("PIU' RISULTATI")
					for item in found
					  print(item.field('FullName').to_s+"  "+item.field('INDI_ID').to_s)
					  #print("\n")
					end
					
					if(params[:whatever]==nil)
						redirect_to controller: 'static_pages', action: 'manage_over_hit', generation_length: params[:generation_length], something: 'else', array_omonymous: found
					else
						family_tree_structure = Array.new
						print(params[:whatever])
						name_id = params[:whatever]
						name = table.find {|row| row['INDI_ID'] == name_id}.field("FullName")

						printTree(name,name_id,table,0,params[:generation_length].to_i,family_tree_structure)
						for item in family_tree_structure
						  print("test items in fts ==> "+item.to_s)
						end
						
						@final_family_tree = family_tree_structure
						#logger.debug "#{family_tree_structure}"
						
						gon.your_array = @final_family_tree
					end
					
				#end
				else
				print("UN SOLO RISULTATO")
					found = table.find {|row| row['FullName'] == params[:fullname]} #=> returns first `row` that satisfies the block.

					if (found==nil)
						flash[:notice] = 'Il nome da te digitato non è presente nel nostro database riprova'
						redirect_to static_pages_draw_tree_submit_path
					else

						family_tree_structure = Array.new

						name=found.field('FullName')
						name_id = table.find {|row| row['FullName'] == name}.field("INDI_ID")

						printTree(name,name_id,table,0,params[:generation_length].to_i,family_tree_structure)
						for item in family_tree_structure
						  print(item)
						end
						
						@final_family_tree = family_tree_structure
						#logger.debug "#{family_tree_structure}"
						
						gon.your_array = @final_family_tree
					end
		end		
		
		end
  
  end

  def manage_over_hit
  
	print(params[:id].to_s+"\n")
	print(params[:something].to_s+"\n")
	#print(params[:array_omonymous])
	print("TEST PRINT GEN LENGTH ====> "+params[:generation_length].to_s)
	collection_omonymous = params[:array_omonymous]
	arr_fullname = collection_omonymous[0].split(",")
	@fullname = arr_fullname[1]
	@result_array = Array.new
	@generation_length = params[:generation_length]
	
	for people in collection_omonymous
		info_array = people.split(',')
		buff_array = Array.new
		string_opt = "nato il: " +info_array[9]+ " a: "+info_array[10]+" || padre: "+info_array[19] + " madre: "+ info_array[21]
		buff_array = [string_opt,info_array[0]]  	
		@result_array.push(buff_array)
	end
  
  
  end

end
