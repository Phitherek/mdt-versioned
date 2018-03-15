require_relative '../../../../lib/mdt/directory_choosers/versioned'

RSpec.describe MDT::DirectoryChoosers::Versioned do
  it 'should have the "versioned" key defined' do
    expect { MDT::DirectoryChoosers::Versioned.key }.not_to raise_error
    expect(MDT::DirectoryChoosers::Versioned.key).to eq('versioned')
  end

  it 'should have "timestamp" and "integer" subkeys' do
    expect { MDT::DirectoryChoosers::Versioned.subkeys }.not_to raise_error
    expect(MDT::DirectoryChoosers::Versioned.subkeys).to eq ['timestamp', 'integer']
  end

  describe '#mkdir' do
    before(:each) do
      @directory_choosers = MDT::DirectoryChoosers::Versioned.new
    end
    it 'should not raise error' do
      expect { @directory_choosers.mkdir('') }.not_to raise_error
    end
  end

  describe '#cd' do
    before(:each) do
      @directory_choosers = MDT::DirectoryChoosers::Versioned.new
    end
    it 'should not raise error' do
      expect { @directory_choosers.cd('') }.not_to raise_error
    end
  end

  describe '#rm' do
    before(:each) do
      @directory_choosers = MDT::DirectoryChoosers::Versioned.new
    end
    it 'should not raise error' do
      expect { @directory_choosers.rm('') }.not_to raise_error
    end
  end
end