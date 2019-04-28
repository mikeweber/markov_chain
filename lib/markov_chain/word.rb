module MarkovChain
  class Word
    attr_reader :word, :tails

    def self.init(word)
      word.is_a?(Word) ? word : Word.new(word)
    end

    def initialize(word)
      @word = word
      @tails = Hash.new { |h, k| h[k] = 0 }
    end

    def add_tail(other)
      @tail_count = nil
      tails[Word.init(other)] += 1
    end

    def pick_next_word(num = rand)
      floor = 0.0
      scores.each do |tail, score|
        floor += score
        return tail if num < floor
      end
      nil
    end

    def scores
      tails.keys.map { |tail| [tail, score(tail)] }
    end

    def score(word)
      self[word] / tail_count.to_f
    end

    def [](word)
      tails[Word.init(word)]
    end

    def tail_count
      @tail_count ||= tails.values.inject(:+)
    end

    def eql?(other)
      other.is_a?(self.class) && self == other
    end

    def ==(other)
      to_s == other.to_s
    end

    def hash
      to_s.hash
    end

    def to_s
      word
    end

    def inspect
      %{#<#{self.class.name}:#{self.object_id} "#{word}">}
    end
  end

  class Terminator < Word
    def initialize
    end

    def scores
      []
    end

    def pick_next_word(*args)
    end

    def to_s
      ''
    end

    def inspect
      %{#<#{self.class.name}:#{self.object_id}>}
    end
  end
end
