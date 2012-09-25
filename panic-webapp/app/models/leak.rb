class Leak < ActiveRecord::Base
  has_many :credentials
  has_many :credentials_snippet, :class_name => "Credential", :limit => 8
  serialize :stats
  after_commit :create_credentials_from_data_csv

  def passwords
    credentials.where("password not null")
  end

  def csv_header
    ""
  end

  def csv_header=(header)
    @csv_header = header.split(/, */).collect { |name| name.to_sym }
  end

  def data_csv=(uploaded_file)
    @data_csv = uploaded_file.read
  end

  def create_credentials_from_data_csv
    return if @updating_stats
    if @data_csv and @csv_header
      @data_csv.each_line do |line|
        row = line.split(/, */)
        params = Hash[@csv_header.zip(row)].select { |attr| [ :email, :password, :username, :hash ].include? attr }
        credential = Credential.new params
        self.credentials << credential
        credential.save
      end
      @updating_stats = true
      recalc_stats
      save
      @updating_stats = false
    end
  end

  def recalc_stats
    # Cache passwords so we don't rebuild this for each calculation
    pws = passwords.map { |p| p.password }

    lengths = pws.collect { |pw| pw.length }
    character_complexities = pws.collect { |pw| pw.character_complexity }
    strengths = pws.collect { |pw| pw.strength }

    self.stats = {
      :length => lengths.summary,
      :character_complexity => character_complexities.summary,
      :strength => strengths.summary
    }
  end
end

class Array
  def numeric_sum
    inject(0.0) { |total, i| total + i.to_f }
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
    big = max + 0.000000001 # This is a hack, but I'm in a hurry.  :-(
    small = min
    step = (big.to_f - small.to_f) / n
    # Produces an array of n evenly spaced values from min to just below max
    keys = (0..n-1).map { |i| small + i * step }
    bucket_hash = Hash[keys.map { |k| [k, 0] }]
    each do |value|
      index = ((value - small) / step).to_i
      hash_index = small + index * step
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
    if dictionary_word?
      length 
    else
      Math.log(length ** character_complexity)
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
