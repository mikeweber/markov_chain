require_relative './word'
require 'pry'

class WordList
  attr_reader :frequencies, :start_words

  def initialize
    @frequencies = Hash.new do |head_hash, head|
      head_hash[head] = Word.init(head)
    end
    @start_words = Hash.new { |h, k| h[k] = 0 }
  end

  def frequency_of(head, tail)
    frequencies[Word.init(head)][tail]
  end

  def add(sentence)
    length, words = break_it_down(sentence)
    start_words[words[0]] += 1
    words.each.with_index do |word, index|
      next if index >= length

      add_pair(word, words[index + 1])
    end
  end

  def add_pair(head, tail)
    self[head].add_tail(tail)
  end

  def [](word)
    frequencies[Word.init(word)]
  end

  def words
    [*non_terminating_words, Terminator.new]
  end

  def non_terminating_words
    frequencies.keys
  end

  private

  def break_it_down(sentence)
    words = sentence.split(/\s+/).map { |word| Word.new(word) }

    [words.length, [*words, Terminator.new]]
  end
end