require 'date'
require 'pry'
require "json"
require 'csv'

module InsertDocument
  class << self

    KumibanTsv = 'kumiban.tsv'
    ImagesCsv = '14_images.csv'
  
    def insert_document
      school_id = '1217'
      folder = []
      json_files_path = []
      datas = []

      SchoolDatabase.switch_to_school(school_id)
      students = CSV.read(KumibanTsv, col_sep: "\t", headers: true)
      #ile = 'images/*/**/*'
      #folder = 'image'
      #files = Hash.new { |hash, key| hash[key] = [] }
      students.each do |student|
        binding.pry
      end

      Dir.glob('Tegaki-API_access_script/api_test_data/0001.ポートフォリオ/100.実証第1校/0003.修正結果/**/*.json') do |item|
        json_files_path << item
      end

      json_files_path.each do |file|
        File.open(file) do |json|
          datas << JSON.load(json)
        end
      end

      datas.each do |data|
        documents = Document.new()
      end

      #Dir::mkdir(folder) unless  Dir.exist?(folder)

      #Dir.glob(file) do |path|
      #  files["#{Dir.pwd}/#{path}"].push(path.slice(7,8),File.basename(path))
      #end

      #images.each do |image|
      #  next unless (files.find { |k, v| v[1] == image['image']}).nil? == false
      #  Dir::mkdir("#{folder}/#{files.find { |k, v| v[1] == image['image']}[1][0]}") unless  Dir.exist?("#{folder}/#{files.find { |k, v| v[1] == image['image']}[1][0]}")
      #  FileUtils.cp(files.find { |k, v| v[1] == image['image']}[0], "#{folder}/#{files.find { |k, v| v[1] == image['image']}[1][0]}/#{files.find { |k, v| v[1] == image['image']}[1][1]}")
      #end

      #images.each do |image|
      #  next if File.exist?(path = "#{Dir.pwd}/#{folder}/#{DateTime.parse(image['created_at']).strftime('%Y%m%d')}/#{image['image']}") == false 
      #  documents = Document.where(created_at: image['created_at'], create_user_id: image['user_id'])
      #  next unless documents.count == 1
      #  document = documents.first
      #  gazou = document.upload_files.new(uuid: UploadFile.generate_uuid, file_name: image['file_name'], file_extension: 'jpg', create_user_id: image['user_id'], created_at: image['created_at'], updated_at: image['updated_at'])
      #  document.save!
      #  s3 = Aws::S3::Resource.new(region: Aws.config[:region])
      #  obj = s3.bucket(ENV['AWS_S3_BUCKET']).object("#{school_id}/#{image['user_id']}/#{gazou.uuid}")
      #  obj.upload_file(path)
      #end
    end
  end
end

InsertDocument.insert_document
