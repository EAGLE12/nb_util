# -*- coding: utf-8 -*-
require 'nb_util/version'
require 'cli'
require 'json'
require 'fileutils'
require "date"
require 'open3'

module NbUtil
  module_function
  def ipynb2tex(target)
    loop do
      your_informations(ARGV[1])
      print "Are you ok with it?: "
      input = STDIN.gets.to_s.chomp
      if input == 'Y' || input == 'y'
        location = Open3.capture3("gem environment gemdir")
        versions = Open3.capture3("gem list nb_util")
        latest_version = versions[0].split(",")
        p cp_lib_data_thesis_gem = File.join(location[0].chomp, "/gems/#{latest_version[0].chomp.gsub(' (','-').gsub(')','')}/lib/data/thesis")
        p cp_lib_data_pieces_gem = File.join(location[0].chomp, "/gems/#{latest_version[0].chomp.gsub(' (','-').gsub(')','')}/lib/data/pieces")
        cp_lib_data_thesis_bundle = File.join(Dir.pwd, '/lib/data/thesis')
        cp_lib_data_pieces_bundle = File.join(Dir.pwd, '/lib/data/pieces')
        re_fig = /(.+\.jpg)|(.+\.jpeg)|(.+\.png)/

        print "\e[32minputfile: \e[0m"
        target = File.expand_path(ARGV[1])
        print "\e[32m#{target}\n\e[0m"
        print "\e[32moutputfile: \e[0m"
        tex_src = target.sub('.ipynb', '.tex')
        print "\e[32m#{tex_src}\n\e[0m"
        target_parent = File.dirname(target)
        target_basename = File.basename(tex_src)
        Open3.capture3("jupyter nbconvert --to latex #{target}")
        lines = File.readlines(tex_src)
        lines.each_with_index do |line, i|
          line.sub!("\documentclass[11pt]{article}",
            "\documentclass[11pt,dvipdfmx]{jsarticle}")
          print "\e[32m#{line}\n\e[0m" if line =~ re_fig  #redにする"\e[31m\e[0m"
          line.sub!(line, '%' + line) if line.include?('.svg')
        end
        File.open(tex_src, 'w') { |file| file.print lines.join }

        FileUtils.mkdir_p(target_parent + '/latex')
        FileUtils.mv(tex_src, target_parent + '/latex')
        replace_figs(File.join(target_parent + '/latex', target_basename))
        revise_lines(File.join(target_parent + '/latex', target_basename))
        split_files(File.join(target_parent + '/latex', target_basename), target)
        FileUtils.mv(target_parent + '/tmp.tex', target_parent + '/split_files/tmp')
        FileUtils.mv(target_parent + '/informations.tex', target_parent + '/split_files/informations')
        mk_thesis_location(target)
        FileUtils.mv(target_parent + '/.splits_location.tex', target_parent + '/thesis')

        mk_xbb(target, re_fig)

        if Dir.exist?(cp_lib_data_pieces_bundle.to_s)
          FileUtils.cp_r(cp_lib_data_pieces_bundle, target_parent)
          FileUtils.cp_r(cp_lib_data_thesis_bundle, target_parent)
        else
          FileUtils.cp_r(cp_lib_data_pieces_gem, target_parent)
          FileUtils.cp_r(cp_lib_data_thesis_gem, target_parent)
        end

=begin
        if (Open3.capture3("bundle exec exe/nb_util ipynb2tex #{target}")) then
          FileUtils.cp_r(cp_lib_data_pieces_bundle, target_parent)
          FileUtils.cp_r(cp_lib_data_thesis_bundle, target_parent)
        else
          FileUtils.cp_r(cp_lib_data_pieces_gem, target_parent)
          FileUtils.cp_r(cp_lib_data_thesis_gem, target_parent)
        end
=end
        mk_latex_and_mv_to_latex(target, target_parent)
        Open3.capture3("open #{target_parent}")
        Open3.capture3("open #{target_parent}/mk_latex/thesis/thesis.tex/")

        exit
        break
      elsif input == 'N' || input == 'n'
        target_parent = File.dirname(target)
        FileUtils.rm_r(File.join(target_parent.to_s, '/informations.tex'))
        break
      end
    end
  end

  def revise_lines(target)
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

  def split_files(target, input_ipynb)
    target_parent = File.absolute_path("../..", target)
    ipynb = JSON.parse(File.read(input_ipynb))
    pickup_ipynb = ipynb["cells"].to_s.split(",")
    chapter = pickup_ipynb.grep(/"# /).map{ |i| i.gsub(/.*# /, '').gsub(/".*/, '') }
    chapter_size = chapter.size
    for num in 0..chapter_size-1 do
      splitters = [ ["\\section{#{chapter[num]}}", target_parent + "/chapter#{num}.tex", FileUtils.mkdir_p(target_parent + "/split_files/chapter#{num}")],
        ["\\begin{Verbatim}", target_parent + '/tmp.tex', FileUtils.mkdir_p(target_parent + '/split_files/tmp')]]
      cont = File.read(target)
      splitters.reverse.each do |splitter|
        split = cont.split(splitter[0])
        split[1].to_s.gsub!(/subsection/, 'section')
        split[1].to_s.gsub!(/subsubsection/, 'subsection')
        split[1].to_s.gsub!(/paragraph/, 'subsubsection')
        cont = split[0]

        File.open(splitter[1], 'w') do |f|
          f.print splitter[0].gsub!(/section/, 'chapter')
          if num+1 != chapter_size
            f.print split[1].sub!(/ \\section{#{chapter[num+1]}}\\label.*/m, '')
          end
          if num+1 == chapter_size
            f.print split[1]
          end
        end
      end
      FileUtils.mv(target_parent + "/chapter#{num}.tex", target_parent + "/split_files/chapter#{num}")
    end
  end

  def replace_figs(target)
    lines = File.readlines(target)
    counter = -1
    # settings of each
    data = [["This", 150, -4, 0]]
    lines.each_with_index do |line, i|
      lines[i] = "   \\usepackage{wrapfig}\n"+line if line.include?("\\usepackage{graphicx}")
      lines[i] = '%' + line if line.include?("\\renewcommand{\\includegraphics}")
      lines[i] = '%' + line if line.include?("\\DeclareCaptionLabelFormat")
      lines[i] = '%' + line if line.include?("\\captionsetup{labelformat=nolabel}")
      if m = line.match(/\\includegraphics\{(.+)\}/)
        counter += 1
        file_name, label, size, top, bottom = [m[1], data[counter]].flatten
        caption = lines[i + 1]
        label_name = file_name.to_s.gsub('figs', '').gsub('.png', '').gsub('/', '')
        wrap_figs = <<"EOS"
\\begin{center}
\\includegraphics[width=#{size}mm]{../../#{file_name}}
\\end{center}
#{caption}
\\label{fig:#{label}}
EOS
        # \\vspace{#{top}\\baselineskip}
        # \\vspace{#{bottom}\\baselineskip}

        lines[i] = wrap_figs
        lines.delete_at(i + 1) # if no caption, comment out here
      end
    end

    File.open(target, 'w') do |f|
      lines.each{|line| f.print line}
    end
  end

  def mk_xbb(target, re_fig)
    target_parent = File.absolute_path("../..", target)
    FileUtils.mkdir_p(target_parent + '/figs')
    FileUtils.cd(target_parent + '/figs')
    Dir.entries('.').each do |file|
      next unless file =~ re_fig
      m = file.split('.')[0..-2]
      next if File.exist?(m.join('.') + '.xbb')
      command = "extractbb #{file}"
      p command
      system command
    end
  end

  def your_informations(target)
    info = Array.new(3)

    print "thesis title: "
    info[0] = STDIN.gets.to_s.chomp
    print "student number(eight-digit): "
    info[1] = STDIN.gets.to_s.chomp
    print "your name: "
    info[2] = STDIN.gets.to_s.chomp

    target_parent = File.dirname(target)
    d = Date.today
    infomations = <<"EOS"
\\title{卒業論文\\\\#{info[0]}}
\\author{関西学院大学理工学部\\\\情報科学科 西谷研究室\\\\#{info[1]} #{info[2]}}
\\date{#{d.year}年3月}
\\begin{document}
\\maketitle
\\newpage
EOS
    FileUtils.mkdir_p(target_parent + '/split_files/informations')
    File.open(target_parent + '/informations.tex', "w") do |f|
      f.print(infomations)
    end
  end

  def mk_latex_and_mv_to_latex(target, target_parent)
    mk_latex = FileUtils.mkdir_p(File.join(File.dirname(target),'/mk_latex'))
    if Dir.exist?(File.join(mk_latex[0].to_s, '/pieces'))
      d = Date.today
      old_file = File.join(File.dirname(target),"/old/#{d.year}#{d.month}#{d.day}")
      FileUtils.mkdir_p(old_file)
      FileUtils.cp_r(mk_latex[0], old_file)
      FileUtils.rm_r(mk_latex[0])
    end
    mk_latex = FileUtils.mkdir_p(File.join(File.dirname(target),'/mk_latex'))

    #p split_files = FileUtils.mkdir_p(File.join(File.dirname(target),'/mk_latex/split_files'))
    split_files = File.join(target_parent, '/split_files')
    pieces = File.join(target_parent, '/pieces')
    thesis = File.join(target_parent, '/thesis')
    latex = File.join(target_parent, '/latex')

    FileUtils.mv(split_files, File.join(mk_latex[0], "/split_files"))
    FileUtils.mv(pieces, mk_latex[0])
    FileUtils.mv(thesis, mk_latex[0])
    FileUtils.mv(latex, mk_latex[0])
  end

  def mk_thesis_location(input_ipynb)
    target_parent = File.dirname(input_ipynb)
    ipynb = JSON.parse(File.read(input_ipynb))
    pickup_ipynb = ipynb["cells"].to_s.split(",")
    chapter = pickup_ipynb.grep(/"# /).map{ |i| i.gsub(/.*# /, '').gsub(/".*/, '') }
    chapter_size = chapter.size

    FileUtils.mkdir_p(target_parent + '/thesis')
    File.open(target_parent + '/.splits_location.tex', "w") do |f|
      for num in 0..chapter_size-1 do
        f.print("\\input{../split_files/chapter#{num}/chapter#{num}}\n")
      end
    end
  end
end
