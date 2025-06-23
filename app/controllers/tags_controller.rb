# app/controllers/tags_controller.rb
class TagsController < ApplicationController
  def autocomplete
    tags = ActsAsTaggableOn::Tag.pluck(:name)
    render json: tags
  end
end
