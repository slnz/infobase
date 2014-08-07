module CruEnhancements
  extend ActiveSupport::Concern

  included do |c|
    includes = []
    if defined?(c::HAS_MANY)
      has_many *c::HAS_MANY
      includes += c::HAS_MANY
    end
    if defined?(c::HAS_ONE)
      has_one *c::HAS_ONE
      includes += c::HAS_ONE
    end
    includes.each do |relationship|
      define_method(relationship) do
        add_since(object.send(relationship))
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

  def include_associations!
    includes = scope[:include] if scope.is_a? Hash
    rels = []
    rels += self.class::HAS_MANY if defined?(self.class::HAS_MANY)
    rels += self.class::HAS_ONE if defined?(self.class::HAS_ONE)
    if includes && rels.present?
      includes.each do |rel|
        include!(rel.to_sym) if rels.include?(rel.to_sym)
      end
    else
      super
    end
  end

  def attributes
    hash = super
    hash.delete_if {|k, v| v.blank?}
    hash
  end

end
