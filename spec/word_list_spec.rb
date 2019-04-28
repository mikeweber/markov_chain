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
      list.add_pair('foo', 'baz')
      list.add_pair('foo', 'bar')
    }.to change { list.frequency_of('foo', 'bar') }.from(0).to(2)
      .and change { list.frequency_of('foo', 'baz') }.from(0).to(1)
  end

  it 'breaks down a sentence into standardized words' do
    list = WordList.new
    list.add('I am what I am.')
    expect(list.frequency_of('I', 'am')).to eq(1)
    expect(list.frequency_of('I', 'am.')).to eq(1)
    expect(list.frequency_of('am', 'what')).to eq(1)
    expect(list.frequency_of('what', 'I')).to eq(1)
    expect(list.frequency_of('am.', Terminator.new)).to eq(1)
    expect(list.start_words).to include('I')

    list.add('I am so dazed and confused.')
    expect(list.frequency_of('I', 'am')).to eq(2)
    expect(list.frequency_of('I', 'am.')).to eq(1)
    expect(list.frequency_of('am', 'what')).to eq(1)
    expect(list.frequency_of('what', 'I')).to eq(1)
    expect(list.frequency_of('am.', Terminator.new)).to eq(1)
    expect(list.frequency_of('am', 'so')).to eq(1)
    expect(list.frequency_of('so', 'dazed')).to eq(1)
    expect(list.frequency_of('dazed', 'and')).to eq(1)
    expect(list.frequency_of('and', 'confused.')).to eq(1)
    expect(list.frequency_of('confused.', Terminator.new)).to eq(1)
    expect(list.start_words).to include('I')

    list.add("I'm dazed and confused, I am.")
    expect(list.frequency_of('I', 'am')).to eq(2)
    expect(list.frequency_of('I', 'am.')).to eq(2)
    expect(list.frequency_of('am', 'what')).to eq(1)
    expect(list.frequency_of('what', 'I')).to eq(1)
    expect(list.frequency_of('am.', Terminator.new)).to eq(2)
    expect(list.frequency_of('am', 'so')).to eq(1)
    expect(list.frequency_of('so', 'dazed')).to eq(1)
    expect(list.frequency_of('dazed', 'and')).to eq(2)
    expect(list.frequency_of('and', 'confused.')).to eq(1)
    expect(list.frequency_of("I'm", 'dazed')).to eq(1)
    expect(list.frequency_of('and', 'confused,')).to eq(1)
    expect(list.frequency_of('confused.', Terminator.new)).to eq(1)
    expect(list.frequency_of('confused,', 'I')).to eq(1)
    expect(list.start_words).to include('I')
    expect(list.start_words).to include("I'm")

    list.add("I'm not what I seem.")
    expect(list.frequency_of('I', 'am')).to eq(2)
    expect(list.frequency_of('I', 'am.')).to eq(2)
    expect(list.frequency_of('am', 'what')).to eq(1)
    expect(list.frequency_of('what', 'I')).to eq(2)
    expect(list.frequency_of('am.', Terminator.new)).to eq(2)
    expect(list.frequency_of('am', 'so')).to eq(1)
    expect(list.frequency_of('so', 'dazed')).to eq(1)
    expect(list.frequency_of('dazed', 'and')).to eq(2)
    expect(list.frequency_of('and', 'confused,')).to eq(1)
    expect(list.frequency_of('and', 'confused.')).to eq(1)
    expect(list.frequency_of('confused.', Terminator.new)).to eq(1)
    expect(list.frequency_of('confused,', 'I')).to eq(1)
    expect(list.frequency_of("I'm", 'not')).to eq(1)
    expect(list.frequency_of('not', 'what')).to eq(1)
    expect(list.frequency_of('I', 'seem.')).to eq(1)
    expect(list.frequency_of('seem.', Terminator.new)).to eq(1)
    expect(list.start_words).to include('I')
    expect(list.start_words).to include("I'm")
  end
end
