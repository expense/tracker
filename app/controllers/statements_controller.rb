class StatementsController < ApplicationController
  before_action :set_statement, only: [:show, :edit, :update, :destroy]

  def index
    @statements = Statement.all
    respond_with(@statements)
  end

  def show
    respond_with(@statement)
  end

  def new
    @statement = Statement.new
    respond_with(@statement)
  end

  def edit
  end

  def create
    @statement = Statement.new(statement_params)
    @statement.save
    respond_with(@statement)
  end

  def update
    @statement.update(statement_params)
    respond_with(@statement)
  end

  def destroy
    @statement.destroy
    respond_with(@statement)
  end

  private
    def set_statement
      @statement = Statement.find(params[:id])
    end

    def statement_params
      params.require(:statement).permit(:command, :params, :comment, :time)
    end
end
