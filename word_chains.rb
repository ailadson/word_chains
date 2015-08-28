require "set"

class WordChainer
  def initialize(dict_filename)
    @dictionary = unpack_dictionary(dict_filename)
  end

  def adjacent_words(word)
    adjacent = @dictionary.select { |w| one_letter_off?(word, w) }
    adjacent
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source => nil }

    until @current_words.empty?
      new_current_words = []
      @current_words.each do |word|
        explore_current_words(new_current_words, word)
        if @all_seen_words.include?(target)
          @current_words = []
          break
        end
      end
    end
    build_path(target)
  end

  private
  def build_path(target)
    path = [target]

    until @all_seen_words[path.last].nil?
      path << @all_seen_words[path.last]
    end

    path
  end

  def explore_current_words(new_current_words, word)
    new_current_words
    adjacent_words(word).each do |adj_word|

      unless @all_seen_words.include?(adj_word)
        new_current_words << adj_word
        @all_seen_words[adj_word] = word
      end
    end
    @current_words = new_current_words
  end

  def one_letter_off?(word1, word2)
    return false unless word1.length == word2.length

    same_letters = []
    word1.split("").each_with_index do |letter, idx|
      same_letters << letter if letter == word2[idx]
    end

    same_letters.length == word1.length-1 ? true: false
  end

  def unpack_dictionary(file_name)
    dict = []
    File.open(file_name).each{|line| dict << line.chomp }
    Set.new(dict)
  end

end


chainer = WordChainer.new(ARGV[0])
p chainer.run("soon", "snow")
