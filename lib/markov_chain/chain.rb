require 'markov_chain/word_list'

module MarkovChain
  class Chain
    attr_reader :words

    def initialize(word_list)
      @words = word_list
    end

    # Only useful for debugging
    def odds_for(head, tail = Terminator.new)
      words[head].score(tail)
    end

    def generate(starting_words = words.start_words)
      build(pick_start_word(starting_words))
    end

    def build(starting_word)
      sentence = [starting_word]
      next_word = starting_word
      while next_word = words[next_word].pick_next_word.word
        sentence << next_word
      end
      sentence.join(' ') + '.'
    end

    def pick_start_word(starting_words, num = rand)
      head = Word.new('')
      (words.non_terminating_words & starting_words.map { |word| Word.init(word) }).each do |word|
        head.add_tail(word)
      end
      head.pick_next_word(num)
    end

    def inspect
      %{#<#{self.class.name}:#{self.object_id}>}
    end
  end
end
