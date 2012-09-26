class Array
  def numeric_sum
    s = 0.0
    each { |i| s += i }
    return s
  end

  def mean
    numeric_sum / size
  end

  def sample_variance
    m = mean
    inject(0) {|total, i| total + (i-m)**2 } / (self.length - 1).to_f
  end

  def standard_deviation
    Math.sqrt sample_variance
  end

  def median
    sort[size/2]
  end

  def buckets(n)
    return {} if empty?
    big = max + 1 # Push the max out further so the max value has a bucket to go in
    small = min
    if big.to_f - small.to_f < n
      n = (big.to_f - small.to_f).to_i
      step = 1
    else
      step = (big.to_f - small.to_f) / n
    end

    puts "big: #{big}"
    puts "small: #{small}"
    puts "step size: #{step}"

    # Produces an array of n evenly spaced values from min to just above max
    keys = (0..n-1).map { |i| small + i * step }
    bucket_hash = Hash[keys.map { |k| [k, 0] }]
    each do |value|
      index = ((value - small) / step).to_i
      bucket_hash[small + index * step] += 1
    end
    return bucket_hash
  end

  def summary
    {
      :mean => mean,
      :median => median,
      :standard_deviation => standard_deviation,
      :buckets => buckets(20)
    }
  end
end

class String
  @@words = Set.new(File.new("/usr/share/dict/words").read.split("\n"))

  def dictionary_word?
    @@words.include? self
  end

  def strength
    if length < 1
       0.0
    elsif dictionary_word?
      length.to_f
    else
      Math.log(character_complexity ** length)
    end
  end

  def character_complexity
    complexity = 0
    complexity += 26 if self =~ /[a-z]/
    complexity += 26 if self =~ /[A-Z]/
    complexity += 10 if self =~ /\d/
    complexity += 26 if self =~ /[`~!@#$\%^&*()_+-=\\\|;:'",<.>\/?{}\[\]]/
    complexity += 2 if self =~ /\s/
    return complexity
  end
end
