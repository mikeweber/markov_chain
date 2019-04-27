require 'markov_chain'
include MarkovChain

describe MarkovChain::WordList do
  it 'tracks the frequency of word pairs' do
    list = WordList.new
    expect {
      list.add_pair('foo', 'bar')
    }.to change { list.frequency_of('foo', 'bar') }.from(0).to(1)
  end

  it 'matches words regardless of case' do
    list = WordList.new
    expect {
      list.add_pair('foo', 'bar')
      list.add_pair('fOo', 'baz')
      list.add_pair('fOO', 'BAR')
    }.to change { list.frequency_of('foo', 'bar') }.from(0).to(2)
      .and change { list.frequency_of('foo', 'baz') }.from(0).to(1)
  end

  it 'breaks down a sentence into standardized words' do
    list = WordList.new
    list.add('I am what I am.')
    expect(list.frequency_of('i', 'am')).to eq(2)
    expect(list.frequency_of('am', 'what')).to eq(1)
    expect(list.frequency_of('what', 'i')).to eq(1)
    expect(list.frequency_of('am', Terminator.new)).to eq(1)
    expect(list.start_words[Word.new('i')]).to eq(1)

    list.add('I am so dazed and confused')
    expect(list.frequency_of('i', 'am')).to eq(3)
    expect(list.frequency_of('am', 'what')).to eq(1)
    expect(list.frequency_of('what', 'i')).to eq(1)
    expect(list.frequency_of('am', Terminator.new)).to eq(1)
    expect(list.frequency_of('am', 'so')).to eq(1)
    expect(list.frequency_of('so', 'dazed')).to eq(1)
    expect(list.frequency_of('dazed', 'and')).to eq(1)
    expect(list.frequency_of('and', 'confused')).to eq(1)
    expect(list.frequency_of('confused', Terminator.new)).to eq(1)
    expect(list.start_words[Word.new('i')]).to eq(2)

    list.add('Dazed and confused, I am.')
    expect(list.frequency_of('i', 'am')).to eq(4)
    expect(list.frequency_of('am', 'what')).to eq(1)
    expect(list.frequency_of('what', 'i')).to eq(1)
    expect(list.frequency_of('am', Terminator.new)).to eq(2)
    expect(list.frequency_of('am', 'so')).to eq(1)
    expect(list.frequency_of('so', 'dazed')).to eq(1)
    expect(list.frequency_of('dazed', 'and')).to eq(2)
    expect(list.frequency_of('and', 'confused')).to eq(2)
    expect(list.frequency_of('confused', Terminator.new)).to eq(1)
    expect(list.frequency_of('confused', 'I')).to eq(1)
    expect(list.start_words[Word.new('i')]).to eq(2)
    expect(list.start_words[Word.new('dazed')]).to eq(1)
  end
end
