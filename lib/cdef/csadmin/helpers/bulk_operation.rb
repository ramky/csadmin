require 'rubygems'
require 'parseexcel'

module Sinatra
    module BulkOperationHelper
      
      def process_file(params)
        unless params[:file] &&
          (tmpfile = params[:file][:tempfile]) &&
          (name = params[:file][:filename])
          raise "No file selected" 
        end
        directory = "/tmp"
        path = File.join(directory, "bulk_#{Time.now.to_i}")
        File.open(path, "wb") { |f| f.write(tmpfile.read) }
        parse_file(path)
      end

      def parse_file(file)
        workbook = Spreadsheet::ParseExcel.parse(file)
        worksheet = workbook.worksheet(0)

        #format is Order ID, Skus
        records = []
        worksheet.each_with_index { |row, i|
          if row != nil
            next if row.at(0).nil?
            col_a = row.at(0).to_s('latin1')
            col_b = row.at(1).to_s('latin1') unless row.at(1).nil?
            if 0 == i 
              raise "Incorrect format!" unless 'ORDER ID' == col_a.upcase  
              next
            end
            records << [col_a, col_b]
          end
        }
        records
      end

  end # module BulkOperationHelper

  helpers BulkOperationHelper
end
