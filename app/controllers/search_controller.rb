class SearchController < ApplicationController
  skip_authorization_check

  def search
    set_params
    perform_search unless @query.empty?
  end

  private

  def set_params
    @scope = params[:scope] || 'all'
    @query = params[:q].to_s
    @page  = params[:page] || 1
  end

  def perform_search
    if @scope == 'all'
      @result = ThinkingSphinx.search ThinkingSphinx::Query.escape(@query),
                  classes: [Question, Answer, Comment, User], page: @page
    else
      @result = model_klass.search ThinkingSphinx::Query.escape(@query), page: @page
    end
  end

  def model_klass
    @scope.classify.constantize
  end

end
