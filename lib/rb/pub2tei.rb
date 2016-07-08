require 'nokogiri'
require 'json'
require 'open3'

class Pub2tei

  def self.main(_input_arg,_meta_arg,output_arg)
    json_dtd = JSON.parse(File.read("../lib/json/dtd.json"))
    out_generator = OutGenerator.new(output_arg)

    Dir[_input_arg + "/" + "*.xml"].each do |file|

      name = File.basename(file)
      xml = File.read(file)
      doc = Nokogiri::XML(xml)
      dtd = json_dtd[doc.internal_subset.system_id]

      puts "processing file : #{file} with dtd : #{dtd}"
      o_xmllint,e_xmllint, s_xmllint = Open3.capture3("xmllint --format --valid --path #{dtd} #{file}")

      o_xsltproc,e_xsltproc, s_xsltproc = Open3.capture3("xsltproc --novalid ../lib/xsl/remove_dtd.xsl -", :stdin_data=>o_xmllint)

      out_generator.generate_file(output_arg, name, o_xsltproc, e_xmllint, e_xsltproc, s_xsltproc,dtd)

      out_generator.create_dtd_entry(file,name,dtd)

    end
  end
end