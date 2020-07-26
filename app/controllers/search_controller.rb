class SearchController < ApplicationController
  skip_authorization_check

  def search
    set_params
    @result = Services::FulltextSearch.new(@query, @scope, params[:page]).call unless @query.empty?
  end

  private

  def set_params
    @scope = params[:scope] || 'all'
    @query = params[:q].to_s
  end
end
