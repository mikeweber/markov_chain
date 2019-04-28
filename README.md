# Markov Chain
From [Wikipedia](https://en.wikipedia.org/wiki/Markov_chain) A Markov chain is a
stochastic model describing a sequence of possible events in which the probability
of each event depends only on the state attained in the previous event.

This is a mental exercising to implement the Markov chain algorithm in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'markov_chain'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install markov_chain

## Usage

Create a WordList, add a number a sentences to the WordList, and it will build up the
probabilities for words following each other. Once the system is trained, the word list
can be passed to a MarkovChain object, which can generate new sentences.

```ruby
list = WordList.new
list.add('I am what I am')
list.add('Where am I?')
list.add('I am dazed and confused')
MarkovChain.new(list).generate # => "Where am what I am dazed and confused"
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
