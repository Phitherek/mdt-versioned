require_relative '../../../../lib/mdt/commands/versioned'

RSpec.describe MDT::Commands::Versioned do
  it 'should have the "versioned" key defined' do
    expect { MDT::Commands::Versioned.key }.not_to raise_error
    expect(MDT::Commands::Versioned.key).to eq('versioned')
  end

  it 'should have "link_current", "link_shared" and "cleanup" subkeys' do
    expect { MDT::Commands::Versioned.subkeys }.not_to raise_error
    expect(MDT::Commands::Versioned.subkeys).to eq ['link_current', 'link_shared', 'cleanup']
  end

  describe '#execute' do
    before(:each) do
      @command = MDT::Commands::Versioned.new
    end
    it 'should not raise error' do
      expect { @command.execute('') }.not_to raise_error
    end
  end
end