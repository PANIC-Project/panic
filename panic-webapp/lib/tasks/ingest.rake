namespace :ingest do
  desc 'Ingest a CSV file'
  task :csv, [:leak, :file, :header] => [ :environment ] do |taskname, args|
    unless args[:leak] and args[:file] and args[:header]
      puts "Usage: rake ingest:csv[<leakname>,<filename>,<header>]"
      exit 1
    end
    leak = Leak.find_by_name args[:leak]

    unless leak
      puts "Couldn't find a leak by the name '#{args[:leak]}'"
      exit 1
    end

    file = File.new(File.expand_path args[:file])
    header = args[:header].gsub('|', ',')
    puts "Parsing #{args[:file]} into #{leak.name}\n\twith header: #{header}"

    leak.csv_header = header
    leak.data_csv = file
    leak.create_credentials_from_data_csv
  end
end
