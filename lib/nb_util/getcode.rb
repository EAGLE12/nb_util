require 'nb_util/version'
require 'cli'
require 'json'
require 'pp'

module NbUtil
  module_function
  def getcode(argv0)
    input_filename = ARGV[1]
    ipynb = JSON.parse(File.read(input_filename))
    ipynb_filename = ARGV[2] || input_filename.gsub(/(.ipynb)$/, '')    
    hash = {}
    i = 0
    ipynb["cells"].each do |k, v|
      hash[i.to_s] = k
      i += 1
    end
    for j in 0..i-1 do
      var="@hash#{j}"
      eval("#{var}={}")
      hash[j.to_s].each do |k, v|
        eval("#{var}[k] = v")
      end
    end

    flag = 0
    source_count = 0
    @getcode = ""
    for i in 0..j - 1 do
      eval("if @hash#{i}[\"cell_type\"] != \"code\" then flag = 1 end")
      if flag == 0 then
        eval("puts @getcode = @hash#{i}[\"source\"]")
        source_count = source_count + 1
        output_filename = ipynb_filename + source_count.to_s + ".rb"
        File.open(output_filename, 'w+') do |f|
          f.puts(@getcode)
        end
      end
      flag = 0
    end
  end
end
