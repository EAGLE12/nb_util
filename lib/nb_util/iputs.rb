require 'nb_util/version'
require 'cli'
require 'json'

module NbUtil
  module_function
  def iputs(argv0)
    ipynb = JSON.load(File.read(ARGV[1]))
    ipynb.each do |cells|
      next unless cells.include?("cells")
      cells[1].each do |cell|
        cell["source"].each do |line|
          print line
        end
      end
    end
  end
end
