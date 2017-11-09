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

    desc "convert [input file name]", "convert yaml to ipynb." # コマンドの使用例と、概要
    def convert(argv0) # コマンドはメソッドとして定義する
     NbUtil.convert(ARGV[1])
    end

  end
end

