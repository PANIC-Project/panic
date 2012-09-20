class Leak < ActiveRecord::Base
  has_many :credentials
  after_commit :create_credentials_from_data_csv

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
    if @data_csv and @csv_header
      @data_csv.each_line do |line|
        row = line.split(/, */)
        params = Hash[@csv_header.zip(row)].select { |attr| [ :email, :password, :username, :hash ].include? attr }
        credential = Credential.new params
        self.credentials << credential
        credential.save
      end
    end
  end
end
