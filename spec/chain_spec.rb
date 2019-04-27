require 'markov_chain'
include MarkovChain

describe MarkovChain::Chain do
  it 'takes in a word list' do
    list = WordList.new
    list.add('I am what I am')

    markov = Chain.new(list)
    expect(markov.odds_for('I', 'am')).to eq(1)
    expect(markov.odds_for('am', 'what')).to eq(0.5)
    expect(markov.odds_for('am')).to eq(0.5)
    expect(markov.odds_for('what', 'I')).to eq(1)
  end

  it 'cannot pick a starting word when the passed in list is not in the WordList' do
    list = WordList.new
    list.add('I am what I am')

    markov = Chain.new(list)
    start = markov.pick_start_word(['foo'])
    expect(start).to be_nil
  end

  it 'can build sentences from a word list and starting word' do
    list = WordList.new
    list.add('I am what I am')

    markov = Chain.new(list)
    expect(markov.build('I')).to be_a(String)
  end

  it 'can build sentences from a word list and a starting list' do
    list = WordList.new
    list.add('I am what I am')

    markov = Chain.new(list)
    expect(markov.generate(['I', 'am'])).to be_a(String)
  end
end

