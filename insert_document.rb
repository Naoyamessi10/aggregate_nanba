module InsertDocument
  class << self
    DIRECTORY = 'Tegaki-API_access_script'.freeze
    FILEPATH = 'Tegaki-API_access_script/api_test_data/0001.ポートフォリオ/100.実証第1校'.freeze
    KUMIBANTSV = 'kumiban.tsv'.freeze
    CORRESPONDTABLETSV = "#{FILEPATH}/0004.手書き画像_リクエストID_対応表/20181219145244.tsv".freeze

    def insert_document
      school_id = '1217'
      key1 = ENV['STAGE'] == 'production' ? 931819219 : 59483718
      key2 = ENV['STAGE'] == 'production' ? 834804294 : 132385932

      SchoolDatabase.switch_to_school(school_id)
      user_ids = read_csv
      recognition_datas = read_json

      recognition_datas.each do |data|
        @content = ''
        load_data(data['results'], user_ids)
        user_id = @user_id.to_i ^ key1 ^ key2
        path = "#{Dir.pwd}/#{DIRECTORY}/#{files_path(data['requestId'])}"
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

    private

    def load_data(results, user_ids)
      (0..(results.length - 1)).each do |i|
        next if results[i].nil?
        @title = decision(results[i]) if results[i]['name'] == 'gidai'
        @nen = grade(results[i]) if results[i]['name'] == 'nen'
        @kumi = decision(results[i]) if results[i]['name'] == 'kumi'
        @ban = decision(results[i]) if results[i]['name'] == 'ban'
        @content = "#{@content}#{decision(results[i])}" if results[i]['name'].start_with?('free')
        next unless user_ids.key?("#{@nen}-#{@kumi}-#{@ban}")
        @user_id = user_ids["#{@nen}-#{@kumi}-#{@ban}"]
      end
    end

    def read_csv
      user_ids = {}

      numbers = CSV.read(KUMIBANTSV, col_sep: "\t", headers: true)
      numbers.each do |number|
        user_ids["#{number['grade_code']}-#{number['name']}-#{number['attendance_number']}"] = number['user_id']
      end
      user_ids
    end

    def read_json
      recognition_datas = []

      Dir.glob("#{FILEPATH}/0003.修正結果/**/*.json") do |json_file|
        File.open(json_file) do |json|
          recognition_datas << JSON.load(json)
        end
      end
      recognition_datas
    end

    def files_path(id)
      path = ''
      images = CSV.read(CORRESPONDTABLETSV, col_sep: "\t")
      images.each do |image|
        path = image[0] if image[1] == id
      end
      path
    end

    def grade(data)
      data = data['correction'].nil? ? data['singleLine']['text'] : data['correction']
      'K' + data
    end

    def decision(data)
      data['correction'].nil? ? data['singleLine']['text'] : data['correction']
    end
  end
end

InsertDocument.insert_document
