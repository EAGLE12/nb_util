# -*- coding: utf-8 -*-
require 'pp'
require 'yaml'
require 'json'
require "nb_util/version"
require 'cli'

module NbUtil
  module_function
  directry = "#{Dir.home}"
  def get_name(str)
    array = str.delete(' ').split(/[\/]/)
  end
  name = get_name(directry)
  puts "nb_util says hello, #{name[2]} !!"
end


