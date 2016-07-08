class OutGenerator
  attr_accessor :csv_dtd, :xmllint_log

  def initialize (_csv_dtd_uri)
    @csv_dtd = File.new("#{_csv_dtd_uri}/list_dtd.csv",  "w+")
    @csv_dtd << "file, dtd\n"
    @xmllint_log = {}
  end

  def generate_file(output_arg, name, o_xsltproc, e_xmllint, e_xsltproc, s_xsltproc,dtd)
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
      populate_dtd(e_xmllint,File.basename(dtd))
    end
  end

  def populate_dtd(_e_xmllint, _dtd)
    if (@xmllint_log.has_key?(_dtd))
      @xmllint_log[_dtd].concat(_e_xmllint.split("\n"))
    else
      @xmllint_log[_dtd] = []
      @xmllint_log[_dtd] = _e_xmllint.split("\n")
    end
  end

  def create_dtd_entry (file,name,dtd)
    name = File.basename(file).gsub!(".xml",".json")
    @csv_dtd << "#{name},#{dtd}\n"
  end
end
