require 'nb_util/version'
require 'cli'
require 'json'
require 'pp'

module NbUtil
  module_function
  def getcode(argv0)
    input_filename = ARGV[1]
    ipynb = JSON.load(File.read(input_filename))

    ipynb.each do |key, value|
      #  pp ipynb[value]["source"]
    end

    hash = {}
    i=0
    ipynb["cells"].each do |k, v|
      hash[i.to_s] = k
      i=i+1
    end

    for j in 0..i-1 do
      var="@hash#{j}"
      eval("#{var}={}")
      hash[j.to_s].each do |k, v|
        eval("#{var}[k] = v")
      end
    end

    #p hash2
    flag=0
    for i in 0..j-1 do
      eval("if @hash#{i}[\"cell_type\"] != \"code\" then flag = 1 end")
      if flag == 0 then
        puts "#{i}"
        eval("puts @hash#{i}[\"source\"]")
        puts ""
      end
      flag = 0
    end
  end
end
