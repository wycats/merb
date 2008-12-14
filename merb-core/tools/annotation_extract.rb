# Copyright (c) 2004-2008 David Heinemeier Hansson
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class SourceAnnotationExtractor
  
  class Annotation < Struct.new(:line, :tag, :text)
    
    def to_s(options={})
      s = "[%3d] " % line
      s << "[#{tag}] " if options[:tag]
      s << text
    end
  end

  def self.enumerate(tag, options={})
    extractor = new(tag)
    extractor.display(extractor.find, options)
  end

  attr_reader :tag

  def initialize(tag)
    @tag = tag
  end

  def find(dirs=%w(app lib test))
    dirs.inject({}) { |h, dir| h.update(find_in(dir)) }
  end

  def find_in(dir)
    results = {}

    Dir.glob("#{dir}/*") do |item|
      next if File.basename(item)[0] == ?.

      if File.directory?(item)
        results.update(find_in(item))
      elsif item =~ /\.(?:rb|rxml|xerb|builder|mab|haml)$/
        results.update(extract_annotations_from(item, /#\s*(#{tag}):?\s*(.*)$/))
      elsif item =~ /\.herb|\.jerb|\.erb$/
        results.update(extract_annotations_from(item, /<%\s*#\s*(#{tag}):?\s*(.*?)\s*%>/))
      end
    end

    results
  end

  def extract_annotations_from(file, pattern)
    lineno = 0
    result = File.readlines(file).inject([]) do |list, line|
      lineno += 1
      next list unless line =~ pattern
      list << Annotation.new(lineno, $1, $2)
    end
    result.empty? ? {} : { file => result }
  end

  def display(results, options={})
    results.keys.sort.each do |file|
      puts "#{file}:"
      results[file].each do |note|
        puts "  * #{note.to_s(options)}"
      end
      puts
    end
  end
end

desc "Enumerate all annotations"
task :notes do
  SourceAnnotationExtractor.enumerate "OPTIMIZE|FIXME|TODO", :tag => true
end

namespace :notes do
  desc "Enumerate all DOC annotations"
  task :doc do
    SourceAnnotationExtractor.enumerate "DOC"
  end

  desc "Enumerate all OPTIMIZE annotations"
  task :optimize do
    SourceAnnotationExtractor.enumerate "OPTIMIZE"
  end

  desc "Enumerate all FIXME annotations"
  task :fixme do
    SourceAnnotationExtractor.enumerate "FIXME"
  end

  desc "Enumerate all TODO annotations"
  task :todo do
    SourceAnnotationExtractor.enumerate "TODO"
  end
end