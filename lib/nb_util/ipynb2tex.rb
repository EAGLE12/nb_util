# -*- coding: utf-8 -*-
require 'nb_util/version'
require 'cli'
require 'json'
#require 'colorize'
require 'fileutils'
require "date"

module NbUtil
  module_function
  class Ipynb2tex
    RE_FIGS_EXT = /(.+\.jpg)|(.+\.jpeg)|(.+\.png)/
    info = your_informations
    loop do
      puts ">上記の情報で実行する場合は「Y」、終了する場合は「N」を入力して下さい。"
      input = STDIN.gets.to_s.chomp
      if input == 'Y' || input == 'y'
        p target = ARGV[1]
        p tex_src = target.sub('.ipynb', '.tex')
        system "jupyter nbconvert --to latex #{target}"
        lines = File.readlines(tex_src)
        lines.each_with_index do |line,i|
          line.sub!("\documentclass[11pt]{article}",
            "\documentclass[11pt,dvipdfmx]{jsarticle}")
          print line.red if line =~ RE_FIGS_EXT
          line.sub!(line, '%' + line) if line.include?('.svg')
        end
        File.open(tex_src, 'w') { |file| file.print lines.join }
        FileUtils.mkdir_p('latex')
        FileUtils.mv(tex_src, 'latex')
        replace_figs(File.join('latex',tex_src))
        revise_lines(File.join('latex',tex_src))
        split_files(File.join('latex',tex_src))
        FileUtils.mv('intro.tex', './split_files/intro')
        FileUtils.mv('background.tex', './split_files/background')
        FileUtils.mv('method.tex', './split_files/method')
        FileUtils.mv('result.tex', './split_files/result')
        FileUtils.mv('summary.tex', './split_files/summary')
        FileUtils.mv('tmp.tex', './split_files/tmp')
        FileUtils.mv('informations.tex', './split_files/informations')
        mk_xbb
        exit
        break
      elsif input == 'N' || input == 'n'
        p '作業を中断します'
        break
      else
        p "「Y」又は「N」を入力して下さい"
      end

      def self.revise_lines(target)
        bugs = [['\end{quote}',:chomp]]
        lines = File.readlines(target)
        lines.each do |line|
          bugs.each do |bug|
            if line.include?(bug[0])
              p line
              line.chomp!
            end
          end
        end

        File.open(target,'w') do |f|
          lines.each{|line| f.print line}
        end
      end

      def self.split_files(target)
        splitters = [ ["\\section{序論}","intro.tex", FileUtils.mkdir_p("./split_files/intro")],
          ["\\section{物理的背景}","background.tex", FileUtils.mkdir_p("./split_files/background")],
          ["\\section{視覚化}","method.tex", FileUtils.mkdir_p("./split_files/method")],
          ["\\section{結果}","result.tex", FileUtils.mkdir_p("./split_files/result")],
          ["\\section{総括}","summary.tex", FileUtils.mkdir_p("./split_files/summary")],
          ["\\begin{Verbatim}","tmp.tex", FileUtils.mkdir_p("./split_files/tmp")]]
        cont = File.read(target)
        splitters.reverse.each do |splitter|
          split = cont.split(splitter[0])
          split[1].to_s.gsub!(/subsection/, 'section')
          split[1].to_s.gsub!(/subsubsection/, 'subsection')
          split[1].to_s.gsub!(/paragraph/, 'subsubsection')
          cont = split[0]
          File.open(splitter[1],'w') do |f|
            f.print splitter[0].gsub!(/section/, 'chapter')
            f.print split[1]
          end
        end
      end

      def self.replace_figs(target)
        lines = File.readlines(target)
        counter = -1
        # settings of each
        data = [["This",150,-4,0]]
        lines.each_with_index do |line, i|
          lines[i] = "   \\usepackage{wrapfig}\n"+line if line.include?("\\usepackage{graphicx}")
          lines[i] = '%' + line if line.include?("\\renewcommand{\\includegraphics}")
          lines[i] = '%' + line if line.include?("\\DeclareCaptionLabelFormat")
          lines[i] = '%' + line if line.include?("\\captionsetup{labelformat=nolabel}")
          if m = line.match(/\\includegraphics\{(.+)\}/)
            counter += 1
            file_name, label, size, top, bottom = [m[1], data[counter]].flatten
            p caption = lines[i + 1]
            wrap_figs = <<"EOS"
\\begin{wrapfigure}{r}{#{size}mm}
\\begin{center}
\\includegraphics[bb= 0 0 1024 768, width=#{size}mm]{../#{file_name}}
#{caption}
\\label{fig:#{file_name}}
\\end{center}
\\end{wrapfigure}
EOS
            # \\vspace{#{top}\\baselineskip}
            # \\vspace{#{bottom}\\baselineskip}

            puts lines[i] = wrap_figs
            lines.delete_at(i+1) # if no caption, comment out here
          end
        end

        File.open(target,'w') do |f|
          lines.each{|line| f.print line}
        end
      end

      def self.mk_xbb
        FileUtils.mkdir_p('./figs')
        FileUtils.cd('./figs')
        Dir.entries('.').each do |file|
          next unless file =~ RE_FIGS_EXT
          p m = file.split('.')[0..-2]
          next if File.exists?(m.join('.')+'.xbb')
          command = "extractbb #{file}"
          puts command.light_blue
          system command
        end
      end

      def self.your_informations
        info = Array.new(3)

        print "卒論の題目: "
        info[0] = STDIN.gets.to_s.chomp
        print "学籍番号（7桁）: "
        info[1] = STDIN.gets.to_s.chomp
        print "あなたの名前: "
        info[2] = STDIN.gets.to_s.chomp

        d = Date.today
        infomations = <<"EOS"
\\title{卒業論文\\\\#{info[0]}}
\\author{関西学院大学理工学部\\\\情報科学科 西谷研究室\\\\#{info[1]} #{info[2]}}
\\date{#{d.year}年3月}
\\begin{document}
\\maketitle
\\newpage
EOS
        FileUtils.mkdir_p('./split_files/informations')
        File.open("informations.tex", "w") do |f|
          f.print(infomations)
        end
      end
    end
  end
end
