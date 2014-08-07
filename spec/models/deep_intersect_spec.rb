require 'spec_helper'

describe DeepIntersect do
  context '#&' do
    it 'handles simple array intersection' do
      expect(DeepIntersect.new(%w(a b)) & [:a]).to eq(['a'])
    end

    it 'keeps a hash key and removes hash values' do
      expect(DeepIntersect.new([{ a: :b }]) & [:a]).to eq([:a])
    end

    it 'keeps nested hash values' do
      expect(DeepIntersect.new([{ a: { b: :c } }]) & [:a, :b, :c]).to eq([{ a: { b: :c } }])
    end

    it 'handles a hash that has a value that is an array' do
      array = [{ a: { b: [:c, d: :e] } }]
      expect(DeepIntersect.new(array) & [:a, :b, :c]).to eq([{ a: { b: :c } }])
      expect(DeepIntersect.new(array) & [:a, :b, :d, :e]).to eq([{ a: { b: { d: :e } } }])
      expect(DeepIntersect.new(array) & [:a, :b, :c, :d, :e]).to eq(array)
    end
  end
end
