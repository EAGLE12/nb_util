# join_ipynb.rb
# join ipynbs
require 'nb_util/version'
require 'cli'
require 'pp'
require 'json'

module NbUtil
  module_function
  def combine(argv0, argv1, argv2)
    ipynb0 = JSON.load(File.read(ARGV[1]))
    ipynb1 = JSON.load(File.read(ARGV[2]))

    output_filename = ARGV[3] 
    p output_filename

    ipynb0["cells"].each do |cell|
      pp cell
      ipynb1["cells"] << cell
    end

    File.open(output_filename + ".ipynb", 'w') do |target|
      JSON.dump(ipynb1,target)
    end
  end
end
