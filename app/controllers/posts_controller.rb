class PostsController < ApplicationController
  before_action :authenticate_admin!, except: [:show]
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
	@posts = @posts.sort_by{|obj| -obj.views}
  end

  # GET /posts/1 or /posts/1.json
  def show
  
	@post.views = @post.views + 1
	@post.save
	
	#gestione menu laterale 
	
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
		
		#print(@families)
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
			
			@families = @families
			buff_post = buff_post.sort_by{|obj| obj.id}
			
			#gestione albero come primo elemento del dropdown menu
			family_tree = buff_post.find {|e| e.title == "Albero Genealogico"}
			print("TEST FAMILY TREEE ===> "+family_tree.to_s)
			buff_post.delete(family_tree)
			
			print("################buffpost###################")
			print(buff_post)
			if not(family_tree==nil)
				buff_post.unshift(family_tree)
			end
			print("################buffpost###################")
			
		@couples[family_soprannome] = buff_post
		print(@couples)
		
		end
	
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
	print(@post.body.to_s)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :views, :family, :family_name, :body)
    end
end
