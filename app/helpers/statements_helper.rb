module StatementsHelper

  def statement_params(statement)
    render partial: 'params', locals: { param_list: statement.parsed_params.sort }
  end

end
