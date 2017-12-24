require 'spec_helper'

RSpec.describe HashAttributeAssignment do
  context 'group of tests to break on purpose' do
    it 'breaks' do
      expect(1).to eq 2
    end

    it 'works' do
      expect(1).to eq 1
    end
  end
end
