# -*- coding: utf-8 -*-
require 'pp'
require 'yaml'
require 'json'
require "nb_util/version"
require 'cli'
require 'artii'

module NbUtil
  module_function

  directry = "#{Dir.home}"
  def get_name(str)
    str.delete(' ').split(/[\/]/)
  end
  name = get_name(directry)
#  puts "nb_util says hello, #{name[2]} !!"
  a = Artii::Base.new :font => 'slant'
 # a = Artii::Base.new
  puts a.asciify("nb-util says")
  puts a.asciify("hello, #{name[2]} !!")
end
