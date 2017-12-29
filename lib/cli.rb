# coding: utf-8
require 'pp'
require 'yaml'
require 'json'
require 'thor'


module NbUtil
  class CLI < Thor

    desc "red WORD [OPTION]", "red words print." # コマンドの概要(サンプル)
    method_option :upcase, :aliases => '-u', :desc => "upcases the contents of str"
    method_option :downcase, :aliases => '-d', :desc => "downcases the contents of str"
    def red(word) # コマンドはメソッドとして定義する
      if options[:upcase]
        say(word.upcase, :red)
      elsif options[:downcase]
        say(word.downcase, :red)
      else
        say(word, :red)
      end
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

    desc "ipynb2tex [filename] [option]", "convert ipynb to tex's thiesis format" # コマンドの使用例と、概要
    option :handout, :aliases => '-h', :desc => "convert ipynb to tex's handout format"
    option :delete, :aliases => '-d', :desc => "delete mk_latex and old folder"
    def ipynb2tex(argv0) # コマンドはメソッドとして定義する
      if options[:handout]
        NbUtil.ipynb2tex_handout(ARGV[1])
      elsif options[:delete]
        NbUtil.delete_folder(ARGV[1])
      else
        NbUtil.ipynb2tex_thesis(ARGV[1])
      end
    end
  end
end
