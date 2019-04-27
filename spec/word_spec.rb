require 'spec_helper'
require 'markov_chain'
include MarkovChain

describe MarkovChain::Word do

  it 'strips away any non-alphabetic characters' do
    expect(Word.init('Foo.').to_s).to eq('Foo')
    expect(Word.init('.Foo.').to_s).to eq('Foo')
    expect(Word.init('--bar.').to_s).to eq('bar')
    expect(Word.init('==').to_s).to eq('')
  end

  it 'is blank when none of the characters alpha from the alphabet' do
    expect(Word.init('Foo.')).to_not be_blank
    expect(Word.init('==')).to be_blank
  end

  it 'equals another word regardless of case' do
    w1 = Word.init('Foo')
    w2 = Word.init('fOO')
    w3 = Word.init('fOO')
    w4 = Word.init('bar')

    expect(w1).to_not eql(w4)
    expect(w1).to eql(w2)
    expect(w2).to eql(w3)
    expect(w1).to_not eql('FOO') # Not the same object...
    expect(w1).to eq('FOO') # ... but the same value
  end

  it 'can be used as a hash key' do
    hash = {}
    w1 = Word.init('foo')
    w2 = Word.init('foo')
    w3 = Word.init('bar')

    hash[w1] = 1
    hash[w2] = 2
    hash[w3] = 3
    expect(hash).to eq({ w1 => 2, w3 => 3 })
  end

  it 'tracks the words that follow' do
    word = Word.init('foo')

    word.add_tail('bar')
    expect(word.tail_count).to eq(1)
    word.add_tail('Bar')
    expect(word.tail_count).to eq(2)
    word.add_tail('Baz')
    expect(word.tail_count).to eq(3)

    expect(word['bar']).to eq(2)
    expect(word['baz']).to eq(1)
  end

  it 'gives each word a frequency score' do
    word = Word.init('foo')
    word.add_tail('bar')
    word.add_tail('Bar')
    word.add_tail('Baz')
    expect(word.score('bar')).to eq(2 / 3.0)
    expect(word.score('baz')).to eq(1 / 3.0)
    expect(word.score('foo')).to eq(0.0)
  end

  describe '#next_word' do
    it 'returns nil when a word has no tail' do
      expect(Word.init('foo').pick_next_word).to be_nil
    end

    it 'when it only has one tail returns that tail word' do
      word = Word.init('foo')
      word.add_tail('bar')
      expect(word.pick_next_word).to eq('bar')
    end

    it 'can pick a random word from possible tails' do
      word = Word.init('foo')
      word.add_tail('bar')
      word.add_tail('baz')

      expect(word.pick_next_word(0.0)).to eq('bar')
      expect(word.pick_next_word(0.49)).to eq('bar')
      expect(word.pick_next_word(0.5)).to eq('baz')
      expect(word.pick_next_word(0.99)).to eq('baz')
    end
  end
end
