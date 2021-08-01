class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]


  def index
    @user = current_user
    @book = Book.new
    to = Time.zone.now.end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).sort{|a,b|
      b.favorited_users.includes(:favorites).where(created_at: from..to).size <=>
      a.favorited_users.includes(:favorites).where(created_at: from..to).size
    }
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @newbook = Book.new
    @book_comment = BookComment.new

  end

  def edit

  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
    def book_params
      params.require(:book).permit(:title, :body)
    end

    def ensure_correct_user
      @book = Book.find(params[:id])
      if @book.user != current_user
        redirect_to books_path
      end
    end
end
