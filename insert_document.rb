require 'pry'
require "json"
require 'csv'

module InsertDocument
  class << self

    KumibanTsv = 'kumiban.tsv'
    ImagesTsv = 'Tegaki-API_access_script/api_test_data/0001.ポートフォリオ/100.実証第1校/0004.手書き画像_リクエストID_対応表/20181219145244.tsv'

    def insert_document
      school_id = '1217'
      key1 = 931819219
      key2 = 834804294
      json_files = []
      recognition_datas = []
      user_ids = {}
      current_d = 'Tegaki-API_access_script'

      SchoolDatabase.switch_to_school(school_id)
      numbers = CSV.read(KumibanTsv, col_sep: "\t", headers: true)
      numbers.each do |number|
        user_ids["#{number['grade_code']}-#{number['name']}-#{number['attendance_number']}"] = number['user_id']
      end

      Dir.glob('Tegaki-API_access_script/api_test_data/0001.ポートフォリオ/100.実証第1校/0003.修正結果/**/*.json') do |json_file|
        json_files << json_file
      end

      json_files.each do |file|
        File.open(file) do |json|
          recognition_datas << JSON.load(json)
        end
      end

      recognition_datas.each do |data|
        (0..(data['results'].length - 1)).each do |i|
          next if data['results'][i].nil?
          @title = decision(data['results'][i]) if data['results'][i]['name'] == 'gidai'
          @nen = grade(data['results'][i]) if data['results'][i]['name'] == 'nen'
          @kumi = decision(data['results'][i]) if data['results'][i]['name'] == 'kumi'
          @ban = decision(data['results'][i]) if data['results'][i]['name'] == 'ban'
          @content = "#{@content}#{decision(data['results'][i])}" if data['results'][i]['name'].start_with?('free')
        end
        next unless user_ids.key?("#{@nen}-#{@kumi}-#{@ban}")
        user_id = user_ids["#{@nen}-#{@kumi}-#{@ban}"]
        user_id = user_id.to_i ^ key1 ^ key2
        path = "#{Dir.pwd}/#{current_d}/#{files_path(data['requestId'])}"
        next if File.extname(path).slice(1..-1).nil?

        ActiveRecord::Base.transaction do
          document = Document.new(title: @title, content: @content, create_user_id: user_id)
          gazou = document.upload_files.new(uuid: UploadFile.generate_uuid, file_name: File.basename(path), file_extension: File.extname(path).slice(1..-1), create_user_id: user_id)
          document.save!
          s3 = Aws::S3::Resource.new(region: Aws.config[:region])
          obj = s3.bucket(ENV['AWS_S3_BUCKET']).object("#{school_id}/#{user_id}/#{gazou.uuid}")
          obj.upload_file(path)
          activity_record = ActivityRecord.new(record_id: document.id, record_type: 'Document', published: 1, create_user_id: user_id)
          activity_record.save!
        end
      end

    end

    def files_path(id)
      path = ''
      images = CSV.read(ImagesTsv, col_sep: "\t", headers: true)
      images.each do |image|
        path = image[0] if image[1] == id
      end
      path
    end

    private

    def grade(data)
      data = data['correction'].nil? ? data['singleLine']['text'] : data['correction']
      change_grade(data)
    end

    def change_grade(data)
      'K' + data
    end

    def decision(data)
      data['correction'].nil? ? data['singleLine']['text'] : data['correction']
    end

  end
end

InsertDocument.insert_document
