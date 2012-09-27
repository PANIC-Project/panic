class Leak < ActiveRecord::Base
  has_many :credentials
  has_many :credentials_snippet, :class_name => "Credential", :limit => 8
  serialize :stats
  after_commit :create_credentials_from_data_csv

  def password_count # TODO: this is kind of disgusting
    credentials.where("password is not null").size
  end

  def credential_count
    credentials.size
  end

  def passwords
    credentials.where("password is not null").map { |p| p.password }.reject { |p| p == '' or p.nil? }
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
    pws = passwords

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
