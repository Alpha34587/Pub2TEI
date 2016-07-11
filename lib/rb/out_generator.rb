require 'fileutils'

class OutGenerator
  attr_accessor :csv_dtd, :xmllint_log

  def initialize (_csv_dtd_uri)
    @csv_dtd = File.new("#{_csv_dtd_uri}/list_dtd.csv",  "w+")
    @csv_dtd << "file, dtd\n"
    @xmllint_log = {}
    @out_file = ""
  end

  def generate_file(o_xsltproc, e_xmllint, e_xsltproc, s_xsltproc, dtd, output_arg, name)
    if (s_xsltproc.success?)
      @out_file << "#{o_xsltproc}"
    else
      p "ERROR : parsing problem"
      name.gsub!(".xml",".log")
      @out_file << "xmllint error : \n"
      @out_file << "-------------------------------------\n"
      @out_file << "#{e_xmllint}\n"
      @out_file << "xsltproc error :\n"
      @out_file << "-------------------------------------\n"
      @out_file << "#{e_xsltproc}\n"
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

  def write_file(_output_arg, _name, *args)
    if (args.length == 0)
      file = File.open("#{_output_arg}/#{_name}","w")
      file << @out_file
      @out_file = ""
    else
      if args[1] != ""
        file = File.open("#{_output_arg}/#{args[0]}/#{_name}","w")
        file << args[1]
      end
    end
  end

  def self.create_dir(_path)
    unless Dir.exists?(_path)
      FileUtils.mkdir_p(_path)
    end
  end
end
