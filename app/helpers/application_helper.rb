module ApplicationHelper
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def object_cache_key_for(resource, user)
    "#{resource.class.to_s.downcase}-#{resource.id}-#{resource.updated_at.utc.to_s(:number)}-user-#{user&.id}"
  end
end
