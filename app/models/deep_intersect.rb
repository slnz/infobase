class DeepIntersect
  # @param array [Array] Initialize with an array to operate on
  def initialize(array = [])
    @array = array
  end

  # Recursively applies intersection, including filtering out nested hash values that aren't in other_array
  # Examples:
  # DeepIntersect.new([:a, { b: { c: [:d] } }]) & [:a] => [:a]
  # DeepIntersect.new([:a, { b: { c: [:d] } }]) & [:b, :c] => [{ b: :c }]
  # DeepIntersect.new([:a, { b: { c: [:d] } }]) & [:a, :c] => [:a]
  #
  # @param other_array [Array] Array of values that should be present in the return value
  # @return [Array] New array containing only elements existing in `other_array`
  def &(other_array)
    other_array_sympolized = other_array.map(&:to_sym)
    ret_val = []
    @array.each do |key|
      case key
      when Hash
        ret_val += hash_intersect(key, other_array)
      when Array
        ret_val += DeepIntersect.new(key) & other_array
      else
        ret_val << key if other_array_sympolized.include?(key.to_sym)
      end
    end
    ret_val
  end

  private

  # @param hash [Hash]
  # @param array [Array]
  def hash_intersect(hash, array)
    ret_val = []
    hash.each do |k, v|
      next unless array.include?(k)

      values =
        if v.is_a?(Hash)
          hash_intersect(v, array)
        else
          DeepIntersect.new(Array.wrap(v)) & array
        end

      values = values.first if values.length == 1
      ret_val << (values.present? ? { k => values } : k)
    end
    ret_val
  end
end