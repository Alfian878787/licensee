RSpec.describe Licensee::ProjectFiles::ProjectFile do
  let(:filename) { 'LICENSE.txt' }
  let(:mit) { Licensee::License.find('mit') }
  let(:content) { mit.content }
  let(:possible_matchers) { [Licensee::Matchers::Exact] }

  subject { described_class.new(content, filename) }
  before do
    allow(subject).to receive(:possible_matchers).and_return(possible_matchers)
  end
  before { allow(subject).to receive(:length).and_return(mit.length) }
  before { allow(subject).to receive(:wordset).and_return(mit.wordset) }

  it 'stores the content' do
    expect(subject.content).to eql(content)
  end

  it 'stores the filename' do
    expect(subject.filename).to eql(filename)
  end

  it 'returns the matcher' do
    expect(subject.matcher).to be_a(Licensee::Matchers::Exact)
  end

  it 'returns the confidence' do
    expect(subject.confidence).to eql(100)
  end

  it 'returns the license' do
    expect(subject.license).to eql(mit)
  end

  context 'with additional metadata' do
    subject { described_class.new(content, name: filename, dir: Dir.pwd) }

    it 'stores the filename' do
      expect(subject.filename).to eql(filename)
      expect(subject[:name]).to eql(filename)
    end

    it 'stores additional metadata' do
      expect(subject[:dir]).to eql(Dir.pwd)
    end
  end

  context 'to_h' do
    let(:hash) { subject.to_h }
    let(:expected) do
      {
        filename:           'LICENSE.txt',
        content:            mit.content.to_s,
        content_hash:       nil,
        content_normalized: nil,
        matcher:            {
          name:       :exact,
          confidence: 100
        },
        matched_license:    'MIT'
      }
    end

    it 'Converts to a hash' do
      expect(hash).to eql(expected)
    end
  end
end
