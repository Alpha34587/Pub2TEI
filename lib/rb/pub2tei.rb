require 'nokogiri'
require 'json'
require 'open3'

class Pub2tei

  def self.main(_input_arg,_meta_arg,output_arg,_trace)
    json_dtd = JSON.parse(File.read("../lib/json/dtd.json"))

    result_path = "#{output_arg}/result"
    OutGenerator.create_dir(result_path)
    out_generator = OutGenerator.new(result_path)

    if _trace
      OutGenerator.create_dir("#{output_arg}/xmllint_dtd_phase0")
    end

    Dir[_input_arg + "/" + "*.xml"][0..15].each do |file|
      name = File.basename(file)
      name_json = File.basename(file).sub(".xml",".json")
      metadata = JSON.parse(File.read("#{_meta_arg}/#{name_json }"))
      xml = File.read(file)
      doc = Nokogiri::XML(xml)
      dtd = json_dtd[doc.internal_subset.system_id]

      puts "processing file : #{file} with dtd : #{dtd}"
      o_xmllint,e_xmllint, s_xmllint = Open3.capture3("xmllint --format --valid --path #{dtd} #{file}")
      if _trace
        out_generator.write_file(output_arg, name, "xmllint_dtd_phase0", o_xmllint)
      end
      o_xsltproc,e_xsltproc, s_xsltproc = Open3.capture3("xsltproc --novalid ../lib/xsl/remove_dtd.xsl -", :stdin_data=>o_xmllint)

      out_generator.generate_file(o_xsltproc, e_xmllint, e_xsltproc, s_xsltproc,metadata["corpusName"], result_path, name)
      out_generator.write_file(result_path, name)
      out_generator.create_dtd_entry(file,name,dtd)

    end
    out_generator.xmllint_log.each do |key,value|
      xlo = Xlo.new ("#{output_arg}/#{key}.csv")
      xlo.xmllint = value
      xlo.xmllint_aggregate
      xlo.csv_writer
    end
  end
end
