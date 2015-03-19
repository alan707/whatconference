class Acronym
  def initialize(long)
    @long = long
    make_acronym
  end

  attr_reader :long, :short

  private

  def make_acronym
    letters = []
    each_word do |word|
      letters << word[0].upcase
    end
    @short = letters.join
  end

  def each_word
    long.scan(/\w[a-z]+/) do |word|
      yield word
    end
  end
end

