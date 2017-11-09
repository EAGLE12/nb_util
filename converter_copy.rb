# coding: utf-8
require 'pp'
require 'yaml'
require 'json'
require 'optparse'
require "converter/version"

module Converter
  class CLI
    def self.run(argv=[])
      print "Cnverter says 'Hello world'.\n"
      new(argv).execute
    end
    def initialize(argv=[])
      @argv = argv
    end

    def execute
      #    DataFiles.prepare

      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = Converter::VERSION
          puts opt.ver
        }
        opt.on('-c', '--convert','yaml to ipynb convert') {|v|
          readfile(ARGV[1], ARGV[2])
        }
        
      end
      command_parser.parse!(@argv)
      exit
    end

    def readfile(argv0,argv1)
      input_filename = ARGV[0]
      output_filename = ARGV[1] || input_filename.gsub(/(yml|yaml)$/, 'ipynb')
      cont = YAML.load(File.read(ARGV[0]))
      contsinglehash = flatten_hash_from cont
      #pp contsinglehash
      
      contsinglehashneed = contsinglehash.select{|k, v| k.match(/title/) || k.match(/cont/) }
      pp contsinglehashneed
      
      contdiffstring = contsinglehashneed.to_s
      
      contdiffstring.gsub!(/=>/,'')
      str = contsinglehashneed.keys
      contnum=str.count
      for i in 0..contnum do
        ignore = str[i].to_s
        p ignore
        contdiffstring.sub!(/#{ignore}/,'')
      end
      contdiffstring.gsub!(/:\"\"\"/,'# ')
      contdiffstring.gsub!(/\[/,'')
      contdiffstring.gsub!(/\]/,'')
      contdiffstring.gsub!(/{/,'')
      contdiffstring.gsub!(/}/,'')
      contdiffstring.gsub!(/\", :\"\"\"/,'\n')
      contdiffstring.gsub!(/\"/,'')
      contdiffstring.gsub!(/,/,'\n')
      pp contdiffstring

          #cellのデータ
    cellsData = <<EOS
  {         
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "#{contdiffstring}"
   ]
  }
EOS

    meta = <<-EOS
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "test code"
   ]
  },
  #{cellsData}
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.6.2"
  },
  "latex_envs": {
   "LaTeX_envs_menu_present": true,
   "autocomplete": true,
   "bibliofile": "biblio.bib",
   "cite_by": "apalike",
   "current_citInitial": 1,
   "eqLabelWithNumbers": true,
   "eqNumInitial": 1,
   "hotkeys": {
    "equation": "Ctrl-E",
    "itemize": "Ctrl-I"
   },
   "labels_anchors": false,
   "latex_user_defs": false,
   "report_style_numbering": false,
   "user_envs_cfg": false
  },
  "nbTranslate": {
   "displayLangs": [
    "*"
   ],
   "hotkey": "alt-t",
   "langInMainMenu": true,
   "sourceLang": "en",
   "targetLang": "fr",
   "useGoogleTranslate": true
  },
  "toc": {
   "colors": {
    "hover_highlight": "#DAA520",
    "navigate_num": "#000000",
    "navigate_text": "#333333",
    "running_highlight": "#FF0000",
    "selected_highlight": "#FFD700",
    "sidebar_border": "#EEEEEE",
    "wrapper_background": "#FFFFFF"
   },
   "moveMenuLeft": true,
   "nav_menu": {
    "height": "12px",
    "width": "252px"
   },
   "navigate_menu": true,
   "number_sections": true,
   "sideBar": true,
   "threshold": 4,
   "toc_cell": false,
   "toc_section_display": "block",
   "toc_window_display": true,
   "widenNotebook": false
  },
  "varInspector": {
   "cols": {
    "lenName": 16,
    "lenType": 16,
    "lenVar": 40
   },
   "kernels_config": {
    "python": {
     "delete_cmd_postfix": "",
     "delete_cmd_prefix": "del ",
     "library": "var_list.py",
     "varRefreshCmd": "print(var_dic_list())"
    },
    "r": {
     "delete_cmd_postfix": ") ",
     "delete_cmd_prefix": "rm(",
     "library": "var_list.r",
     "varRefreshCmd": "cat(var_dic_list()) "
    }
   },
   "types_to_exclude": [
    "module",
    "function",
    "builtin_function_or_method",
    "instance",
    "_Feature"
   ],
   "window_display": false
  }
 },
 "nbformat": 4,
 "nbformat_minor": 2
}
EOS

    File.open(output_filename, 'w+') do |f|
      f.print(meta)
    end
    end

    # nest hash to single hash
    def flatten_hash_from hash
      hash.each_with_object({}) do |(key, value), memo|
        next flatten_hash_from(value).each do |k, v|
          memo["#{key}.#{k}".intern] = v
        end if value.is_a? Hash
        memo[key] = value
      end
    end  
  end
end 
