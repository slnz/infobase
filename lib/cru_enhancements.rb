module CruEnhancements
  extend ActiveSupport::Concern

  included do |c|
    alias_method :original_attributes, :attributes
    alias_method :old_include_associations!, :include_associations!

    if defined?(c::INCLUDES)
      has_many *c::INCLUDES

      c::INCLUDES.each do |relationship|
        define_method(relationship) do
          add_since(object.send(relationship))
        end
      end
    end

    def include_associations!
      includes = scope[:include] if scope.is_a? Hash
      if includes.present? && defined?(self.class::INCLUDES)
        includes.each do |rel|
          include!(rel.to_sym) if self.class::INCLUDES.include?(rel.to_sym)
        end
      else
        old_include_associations!
      end
    end
  end

  def add_since(rel)
    if scope.is_a?(Hash) && scope[:since].to_i > 0
      rel.where("#{rel.table.name}.updated_at > ?", Time.at(scope[:since].to_i))
    else
      rel
    end
  end

end