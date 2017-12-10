# coding: utf-8
require 'pp'
require 'yaml'
require 'json'
require 'thor'

module NbUtil
  class CLI < Thor

    desc "red WORD", "red words print." # コマンドの概要(サンプル)
    def red(word) # コマンドはメソッドとして定義する
      say(word, :red)
    end

    desc "yaml2ipynb [input filename]", "convert yaml to ipynb" # コマンドの使用例と、概要
    def yaml2ipynb(argv0) # コマンドはメソッドとして定義する
     NbUtil.yaml2ipynb(ARGV[1])
    end

    desc "combine [input file1] [input file2] [output filename]", "combine file1 and file2" # コマンドの使用例と、概要
    def combine(argv0, argv1, argv2) # コマンドはメソッドとして定義する
      NbUtil.combine(ARGV[1], ARGV[2], ARGV[3])
    end

    desc "iputs [filename]", "display ipynb file contents" # コマンドの使用例と、概要
    def iputs(argv0) # コマンドはメソッドとして定義する
      NbUtil.iputs(ARGV[1])
    end

    desc "getcode [filename]", "save in ruby format" # コマンドの使用例と、概要
    def getcode(argv0) # コマンドはメソッドとして定義する
      NbUtil.getcode(ARGV[1])
    end

    desc "ipynb2tex [filename]", "convert ipynb to tex" # コマンドの使用例と、概要
    def ipynb2tex(argv0) # コマンドはメソッドとして定義する
      NbUtil.ipynb2tex(ARGV[1])
    end
  end
end
