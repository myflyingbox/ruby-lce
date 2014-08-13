require 'spec_helper'

describe PaginatedArray do

  subject{ PaginatedArray.new(80,2,25) }
  
  describe '#total_count' do
    it 'returns count' do
      expect(subject.total_count).to eql(80)
    end    
  end
  
  describe '#current_page' do
    it 'returns page number' do
      expect(subject.current_page).to eql(2)
    end    
  end
  
  describe '#per_apge' do
    it 'returns page size' do
      expect(subject.per_page).to eql(25)
    end    
  end

  describe '#total_page' do
    it 'calculates page count' do
      expect(subject.total_page).to eql(4)
    end 
  end
  
  describe '#previous_page' do
    it 'returns previous page number' do
      expect(subject.previous_page).to eql(1)
    end
    context 'there is no previous page' do
      subject{ PaginatedArray.new(80,1,25) }
      it 'returns false' do
        expect(subject.previous_page).to eql(false)
      end
    end
  end

  describe '#next_page' do
    it 'returns next page number' do
      expect(subject.next_page).to eql(3)
    end  
    context 'there is no next page' do
      subject{ PaginatedArray.new(80,4,25) }
      it 'returns false' do
        expect(subject.next_page).to eql(false)
      end
    end      
  end
  
end
