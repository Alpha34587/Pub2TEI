require 'nokogiri'
require 'json'
require 'open3'

class Pub2tei

  def self.main(_input_arg,_meta_arg,output_arg)
    # dtd_doc = []
    # f = File.new("list_dtd.csv",  "w+")
    json_dtd = JSON.parse(File.read("../lib/json/dtd.json"))
    Dir[_input_arg + "/" + "*.xml"].each do |file|
      name = File.basename(file)
      xml = File.read(file)
      doc = Nokogiri::XML(xml)
      dtd = json_dtd[doc.internal_subset.system_id]

      puts "processing file : #{file} with dtd : #{dtd}"
      o_xmllint,e_xmllint, s_xmllint = Open3.capture3("xmllint --format --valid --path #{dtd} #{file}")

      o_xsltproc,e_xsltproc, s_xsltproc = Open3.capture3("xsltproc --novalid ../lib/xsl/remove_dtd.xsl -", :stdin_data=>o_xmllint)

      if (s_xsltproc.success?)
        out_file = File.open("#{output_arg}/#{name}","w")
        out_file << "#{o_xsltproc}"
      else
        p "ERROR : parsing problem"
        name.gsub!(".xml",".log")
        out_file = File.open("#{output_arg}/#{name}","w")
        out_file << "xmllint error : \n"
        out_file << "-------------------------------------\n"
        out_file << "#{e_xmllint}\n"
        out_file << "xsltproc error :\n"
        out_file << "-------------------------------------\n"
        out_file << "#{e_xsltproc}\n"
      end
      # name = File.basename(file).gsub!(".xml",".json")
      # f.write("#{name},#{dtd}\n")
    end
  end
end
